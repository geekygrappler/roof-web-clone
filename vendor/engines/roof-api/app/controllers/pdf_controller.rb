require 'wicked_pdf'
class PdfController < ApplicationController

  def upload_pdf
    quote = Quote.find(params[:id])
    data = quote.data
    professional = quote.professional
    project = quote.project

    professional_attributes = {}
    sections = data['document_attributes']['sections']
    migration = professional.data['migration']
    profile = professional_attributes['profile'] = professional.data['profile_attributes']
    profile['email'] = professional.account.email
    profile['image_url'] = professional.data['profile_attributes']['image_url'] || professional.data['migration']['header_photo'] || nil

    if migration['city'].present? && migration['postcode'].present? && migration['address_1'].present?
      professional_attributes['address'] = professional.data['migration']
    end

    if quote_address = profile['quote_address']
      if quote_address['city'].present? && quote_address['postcode'].present? && quote_address['address_1'].present?
        professional_attributes['address'] = quote_address
      end
    end

    client_attributes = {}
    client_attributes['address'] = project.data['address_attributes']
    client_attributes['profile'] = project.account.user.data['profile_attributes']
    client_attributes['profile']['email'] = project.account.email

    sections = all(sections, quote.data)
    vat = data['total_amount'].to_i * 0.2

    professional_attributes['profile']['phone_number'] = format_phone_number(professional_attributes['profile']['phone_number'])
    client_attributes['profile']['phone_number'] = format_phone_number(client_attributes['profile']['phone_number'])

    views = Rails::Application::Configuration.new(Rails.root).paths["app/views"]
    views_helper = ActionView::Base.new views

    locals = {total: data['total_amount'].to_f / 100, sections: sections, room_overview: data['room_overview'],
              summary: quote.data['summary'], trade_overview: data['trade_overview'], vat: vat.to_f / 100,
              professional: professional_attributes, client: client_attributes, helper: views_helper,
              submitted: parse_submitted(data), guarantee: data['guarantee_length'],
              insurance: data['insurance_amount'], reference: quote.id}

    view = views_helper.render partial: "pdf/pdf", locals: locals

    pdf = WickedPdf.new.pdf_from_string(view)
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket("quote-pdf-#{Rails.env}")
    file_name = "quote-#{params[:id]}.pdf"
    save_path = Rails.root.join('tmp', file_name)
    file = File.new(save_path, "w+")
    file.write(pdf.force_encoding("UTF-8"))
    file.close
    obj = bucket.object(file_name)
    obj.upload_file(save_path)

    render json: {pdf: obj.presigned_url(:get, expires_in: 3600)}
  end


  private

  def all(sections, data)
    room_overview= data['room_overview'] = {}
    trade_overview = data['trade_overview'] = {}
    if sections.present?
      sections.each do |section|
        name = section['name']
        # save name to rooms overview section['name']
        room_overview[name] = 0 if !room_overview[name]
        tasks_by_action = section['tasks_by_action'] = {}
        section_total = 0
        if section['tasks'].present?
          section['tasks'].each do |task|
            action = task['action']
            # save to trade overview
            trade_overview[action] = 0 if !trade_overview[action]
            task_total = task['total'] = task['price'] * task['quantity']
            trade_overview[action] = trade_overview[action] + task_total
            # save to tasks_by_action
            tasks_by_action[action] = {total: 0, tasks: []} if !tasks_by_action[action]
            tasks_by_action[action][:tasks].push(task)
            tasks_by_action[action][:total] = tasks_by_action[action][:total] + task['total']
            section_total = section_total + task_total
          end
          order_categories(section)
          section['total'] = room_overview[name] = section_total
        end
      end
    end
  end

  def parse_submitted(data)
    DateTime.parse(data['submitted_at']).strftime('%d/%m/%Y')
  rescue
    return nil
  end

  def format_phone_number(number)
    return nil if !number
    number = number.to_i.floor.to_s if number.to_s.present?
    number = number.to_s
    number.prepend('0') if number.split('')[0] == '7'
    number
  end

  def order_categories(section)
    categories = ['Preparation', 'Structural', 'Plumbing', 'Electrics', 'Carpentry', 'Bespoke carpentry', 'Plastering', 'Decorating', 'Flooring', 'General']
    tasks_by_action_ordered = {}
    oldCategories = {Plumbing: 'Plumb', Carpentry: 'Build', Plastering: 'Plaster', Decorating: 'Decorate', Flooring: 'Lay', Decorating: 'Tile', Preparation: 'Strip out', Electrics: 'Wire and connect', General: 'Other'}
    categories.each do |cat|
      items = section['tasks_by_action'][cat]
      if !items
        old = oldCategories[cat.to_sym]
        items = section['tasks_by_action'][old]
      end
      tasks_by_action_ordered[cat] = items if items
    end
    section['tasks_by_action'] = tasks_by_action_ordered
  end
end
