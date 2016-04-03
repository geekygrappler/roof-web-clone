require 'csv'

namespace :migrate do

  task :customers => :environment do
    CSV.foreach("#{Rails.root}/db/migration/customers.csv", {headers: true, header_converters: :symbol, converters: :all}) do |row|
      #id,email,encrypted_password,reset_password_token,reset_password_sent_at,
      #remember_created_at,sign_in_count,current_sign_in_at,last_sign_in_at,
      #current_sign_in_ip,last_sign_in_ip,created_at,updated_at,
      #signup_source,notes,location,campaign_id,referral_code,confirmation_token,
      #confirmed_at,confirmation_sent_at,referral_email,first_name,last_name,phone_number,
      #slug,address_1,address_2,city,country,postcode
      row = row.to_hash
      row[:phone_number] = "0#{row[:phone_number]}"
      acc = Account.create({
        email: row[:email],
        password: 'password',
        user_type: 'Customer',
        user_attributes: {
          type: 'Customer',
          profile: {
            first_name: row[:first_name].present? ? row[:first_name] : "please update your first name",
            last_name: row[:last_name].present? ? row[:last_name] : "please update your last name",
            phone_number: row[:phone_number].present? ? row[:phone_number] : "please update your phone number"
          },
          migration: {
            id: row[:id],
            signup_source: row[:signup_source],
            notes: row[:notes],
            location: row[:location],
            referral_code: row[:referral_code],
            referral_email: row[:referral_email],
            address_1: row[:address_1],
            address_2: row[:address_2],
            city: row[:city],
            country: row[:country],
            postcode: row[:postcode]
          }
        }
      })
      if acc.persisted?
        acc.update_column(:encrypted_password, row[:encrypted_password])
      else
        puts "[migrate:customers error.row] #{row}"
        puts "[migrate:customers error] #{acc.errors.full_messages}"
        puts "======"
      end
    end
  end

  task :professionals => :environment do
    CSV.foreach("#{Rails.root}/db/migration/professionals.csv", {headers: true, header_converters: :symbol, converters: :all}) do |row|
      #id,email,encrypted_password,reset_password_token,reset_password_sent_at,
      #remember_created_at,sign_in_count,current_sign_in_at,last_sign_in_at,
      #current_sign_in_ip,last_sign_in_ip,created_at,updated_at,
      #name,profile_photo,header_photo,phone,area,address_1,address_2,city,country,
      #postcode,description,specialities,website,slug,publishable_key,secret_key,
      #stripe_user_id,currency,stripe_account_type,stripe_account_status,
      #confirmation_token,confirmed_at,confirmation_sent_at,
      #first_name,last_name,trading_name,vat_number,company_number,dob,insurance_number,
      #insurance_amount,id_document,insurance_document,insurance_valid_until,
      #business_type,tin,team_size,business_name,admin_notes,business_address_1,
      #business_address_2,business_city,business_postcode
      row = row.to_hash
      *first_name, last_name = row[:name] ? row[:name].split(' ') : []
      first_name = first_name.join(' ') if first_name
      acc = Account.create({
        email: row[:email],
        password: 'password',
        user_type: 'Professional',
        user_attributes: {
          type: 'Professional',
          profile: {
            first_name: row[:first_name].present? ? row[:first_name] : (first_name.present? ? first_name : "please update your first name"),
            last_name: row[:last_name].present? ? row[:last_name] : (last_name.present? ? last_name : "please update your last name"),
            phone_number: row[:phone].present? ? row[:phone] : "please update your phone number",

            info: row[:description],
            :dob => row[:dob],
            :website => row[:website],
            company_name: row[:business_name] || row[:trading_name],
            company_registration_number: row[:company_number],
            :company_vat_number => row[:vat_number],
            :insurance_number => row[:insurance_number],
            :insurance_amount => row[:insurance_amount]

          },
          migration: {
            id: row[:id],
            profile_photo: row[:profile_photo],
            header_photo: row[:header_photo],
            area: row[:area],
            address_1: row[:address_1],
            address_2: row[:address_2],
            city: row[:city],
            country: row[:country],
            postcode: row[:postcode],
            specialities: row[:specialities],
            publishable_key: row[:publishable_key],
            secret_key: row[:secret_key],
            currency: row[:currency],
            stripe_account_type: row[:stripe_account_type],
            stripe_account_status: row[:stripe_account_type],
            business_type: row[:business_type],
            team_size: row[:team_size],
            insurance_valid_until: row[:insurance_valid_until],
            busines_address_1: row[:busines_address_1],
            busines_address_2: row[:busines_address_2],
            busines_city: row[:busines_city],
            busines_postcode: row[:busines_postcode],
            stripe_user_id: row[:stripe_user_id].present? ? row[:stripe_user_id] : nil
          },
          stripe_account: {
            id: row[:stripe_user_id].present? ? row[:stripe_user_id] : nil
          }
        }
      })
      if acc.persisted?
        acc.update_column(:encrypted_password, row[:encrypted_password])
      else
        puts "[migrate:professionals error.row] #{row}"
        puts "[migrate:professionals error] #{acc.errors.full_messages}"
        puts "======"
      end
    end
  end

  task :administrators => :environment do
    CSV.foreach("#{Rails.root}/db/migration/administrators.csv", {headers: true, header_converters: :symbol, converters: :all}) do |row|
      # id,email,encrypted_password,reset_password_token,reset_password_sent_at,
      #remember_created_at,sign_in_count,current_sign_in_at,last_sign_in_at,
      #current_sign_in_ip,last_sign_in_ip,created_at,updated_at,name
      row = row.to_hash
      *first_name, last_name = row[:name] ? row[:name].split(' ') : []
      first_name = first_name.join(' ') if first_name
      acc = Account.create({
        email: row[:email],
        password: 'password',
        user_type: 'Administrator',
        user_attributes: {
          type: 'Administrator',
          profile: {
            first_name: (first_name.present? ? first_name : "please update your first name"),
            last_name: (last_name.present? ? last_name : "please update your last name"),
            phone_number: "please update your phone number",
          },
          migration: {
            id: row[:id]
          }
        }
      })
      if acc.persisted?
        acc.update_column(:encrypted_password, row[:encrypted_password])
      else
        puts "[migrate:administrators error.row] #{row}"
        puts "[migrate:administrators error] #{acc.errors.full_messages}"
        puts "======"
      end
    end
  end

  task :projects => :environment do
    #id,professional_id,user_id,created_at,updated_at,slug,job_token,title,
    #job_description,address_1,address_2,city,country,postcode,source,admin_user_id,
    #location,preferred_start,budget,materials_supplied,brief_completed_at,completed_at,
    #tender_id,project_type,brief_started,meta
    # META: :owner, :plans, :planning_permission, :structural_drawings, :party_wall_agreement
    CSV.foreach("#{Rails.root}/db/migration/projects.csv", {headers: true, header_converters: :symbol, converters: :all}) do |row|
      row = row.to_hash
      meta = JSON.parse(row[:meta] || '{}')
      account  = Account.where("user_type = 'Customer'").joins(:user).where("(users.data->'migration'->>'id')::integer = ?", row[:user_id]).first
      professional  = Account.where("user_type = 'Professional'").joins(:user).where("(data->'migration'->>'id')::integer = ?", row[:professional_id]).first
      administrator  = Account.where("user_type = 'Administrator'").joins(:user).where("(data->'migration'->>'id')::integer = ?", row[:admin_user_id]).first

      project = Project.create({
          account_id: account.try(:id),
          name: row[:title],
          kind: row[:project_type].present? && Project.kinds.include?(row[:project_type].downcase) ? row[:project_type].downcase : 'other',
          brief: {
            :description => row[:job_description] || "Please update description",
            :budget => row[:budget],
            :preferred_start => row[:preferred_start],
            :ownership => meta[:owner],
            :plans => meta[:plans],
            :planning_permission => meta[:planning_permission],
            :structural_drawings => meta[:structural_drawings],
            :party_wall_agreement => meta[:party_wall_agreement]
          },
          address: {
            :street_address => "#{row[:address_1]} #{row[:address_2]}",
            :city => row[:city],
            :postcode => row[:postcode],
            :country => row[:country]
          },
          migration: {
            id: row[:id],
            source: row[:source],
            location: row[:location],
            materials_supplied: row[:materials_supplied],
            brief_started: row[:brief_started],
            brief_completed_at: row[:brief_completed_at],
            completed_at: row[:completed_at],
            tender_id: row[:tender_id]
          }
      })
      if project.persisted?
        project.add_to_professionals professional, true if professional
        project.add_to_administrators administrator, true if administrator
      else project.persisted?
        puts "[migrate:projects error.row] #{row}"
        puts "[migrate:projects error] #{project.errors.full_messages}"
        puts "======"
      end
    end
  end

  task :assets => :environment do
    #id,job_id,file_id,type,created_at,updated_at,file_filename,file_size,file_content_type
    CSV.foreach("#{Rails.root}/db/migration/assets.csv", {headers: true, header_converters: :symbol, converters: :all}) do |row|
      row = row.to_hash
      # only valid files
      if row[:job_id] && row[:file_content_type]
        if project = Project.where("data->'migration' @> ?", {id: row[:job_id]}.to_json).first
          Asset.create({
            project_id: project.id,
            file: row[:file_filename],
            file_size: row[:file_size],
            content_type: row[:file_content_type],
            migration: {
              id: row[:id],
              type: row[:type],
              job_id: row[:job_id],
              file_id: row[:file_id]
            }
          })
        end
      end
    end
  end

  task :shortlists => :environment do
    #id,professional_id,job_id,created_at,updated_at,site_visit,status,is_accepted,site_visit_requested,site_visit_details,approved_by_pro,responded_at
    CSV.foreach("#{Rails.root}/db/migration/shortlists.csv", {headers: true, header_converters: :symbol, converters: :all}) do |row|
      row = row.to_hash
      project = Project.where("data->'migration' @> ?", {id: row[:job_id]}.to_json).first
      professional  = Account.where("user_type = 'Professional'").joins(:user).where("data->'migration' @> ?", {id: row[:professional_id]}.to_json).first.try(:user)

      if project && professional
        project.migration['professional_shortlist_ids'] ||= []
        project.migration['professional_shortlist_ids']  << row[:id]

        professional.migration['professional_shortlist_ids'] ||= []
        professional.migration['professional_shortlist_ids']  << row[:id]
        professional.save
        project.add_to_shortlist professional.account, true

        if row[:site_visit] && time = (DateTime.parse(row[:site_visit]) rescue nil)
          app = Appointment.new(time: time, host: project.account.user, attendant: professional, description: row[:site_visit_details])
          app.save(validate: false)
        end
        if row[:site_visit_requested] && time = (DateTime.parse(row[:site_visit_requested]) rescue nil)
          app = Appointment.new(time: time, host: project.account.user, attendant: professional, description: row[:site_visit_details])
          app.save(validate: false)
        end
      else
        puts "[migrate:shortlists error.row] #{row}"
        puts "[migrate:shortlists error] project or professional not found"
        puts "======"
      end
    end
  end

  task :tender_templates => :environment do
    #id,name,data,created_at,updated_at
    CSV.foreach("#{Rails.root}/db/migration/tender_templates.csv", {headers: true, header_converters: :symbol, converters: :all}) do |row|
      row = row.to_hash
      if row[:data].is_a?(String)
        row[:data] = JSON.parse(row[:data]) rescue nil
      end
      if row[:data] && row[:data]['sections']
        tt = TenderTemplate.create(name: row[:name], document: parse_tender_data(row[:data]), migration: {id: row[:id]})
        unless tt.persisted?
          puts "[migrate:tender_templates error.row] #{row}"
          puts "[migrate:tender_templates error] #{tt.errors.full_messages}"
          puts "======"
        end
      end

    end
  end

  task :tenders => :environment do
    #id,quote_template_id,data,created_at,updated_at
    CSV.foreach("#{Rails.root}/db/migration/tenders.csv", {headers: true, header_converters: :symbol, converters: :all}) do |row|
      row = row.to_hash
      if row[:data].is_a?(String)
        row[:data] = JSON.parse(row[:data]) rescue nil
      end
      if row[:data] && row[:data]['sections']
        ttt = TenderTemplate.where("data->'migration' @> ?", {id: row[:quote_template_id]}.to_json).first
        ppp = Project.where("data->'migration' @> ?", {tender_id: row[:id]}.to_json).first
        if ppp
          tt = Tender.create(project_id: ppp.try(:id), tender_template_id: ttt.try(:id), document: parse_tender_data(row[:data]), migration: {id: row[:id], quote_template_id: row[:quote_template_id]})
          unless tt.persisted?
           puts "[migrate:tenders error.row] #{row}"
           puts "[migrate:tenders error] #{tt.errors.full_messages}"
           puts "======"
          end
        end
      end

    end
  end

  task :quotes => :environment do
    #id,professional_shortlist_id,body,created_at,updated_at,total_cost,
    #deposit,deposit_summary,summary,job_length,liability_insurance,installation_guarantee_length,
    #is_accepted,reference,viewed_by_user,data,submitted
    CSV.foreach("#{Rails.root}/db/migration/quotes.csv", {headers: true, header_converters: :symbol, converters: :all}) do |row|
      row = row.to_hash
      if row[:data].is_a?(String)
        row[:data] = JSON.parse(row[:data]) rescue nil
      end
      if row[:data] && row[:data]['sections']
        pro = Professional.where("(data->'migration'->'professional_shortlist_ids') @> ?", row[:professional_shortlist_id].to_json).first
        ppp = Project.where("(data->'migration'->'professional_shortlist_ids') @> ?", row[:professional_shortlist_id].to_json).first
        if pro && ppp
          tt = Quote.create({
            project_id: ppp.try(:id),
            professional_id: pro.try(:id),
            document: parse_tender_data(row[:data]),
            accepted_at: row[:is_accepted] ? row[:updated_at] : nil,
            submitted_at: row[:submitted] ? row[:updated_at] : nil,
            migration: {
              id: row[:id],
              professional_shortlist_id: row[:professional_shortlist_id],
              body: row[:body],
              deposit: row[:deposit],
              deposit_summary: row[:deposit_summary],
              summary: row[:summary],
              job_length: row[:job_length],
              liability_insurance: row[:liability_insurance],
              installation_guarantee_length: row[:installation_guarantee_length],
              reference: row[:reference],
              viewed_by_user: row[:viewed_by_user]
            }
          })
          unless tt.persisted?
            puts "[migrate:quotes error.row] #{row}"
            puts "[migrate:quotes error] #{tt.errors.full_messages}"
            puts "======"
          end
        end
      end

    end
  end

  task :payments => :environment do
    #id,quote_id,amount,fee_percentage,is_paid,paid_at,payment_summary,
    #created_at,updated_at,reference,due_date,approved,slug,token
    CSV.foreach("#{Rails.root}/db/migration/payments.csv", {headers: true, header_converters: :symbol, converters: :all}) do |row|
      row = row.to_hash

      quote = Quote.where("(data->'migration') @> ?", {id: row[:quote_id]}.to_json).first

      if quote
        customer_id = nil
        if row[:paid_at]
          customer_id = quote.project.account.user_id
        end
        payment = Payment.new({
          quote_id: quote.id,
          professional_id: quote.professional_id,
          project_id: quote.project_id,
          customer_id: customer_id,
          amount: (row[:amount].to_i),
          fee: (row[:amount].to_i) * row[:fee_percentage].to_i / 100,
          paid_at: row[:paid_at],
          due_date: row[:due_date],
          approved_at: row[:approved] ? row[:updated_at] : nil,
          description: row[:payment_summary],
          migration: {
            id: row[:id],
            fee_percentage: row[:fee_percentage].to_i,
            reference: row[:reference],
          }
        })
        payment.save(validate: !row[:paid_at].present?)
        unless payment.persisted?
         puts "[migrate:payments error] #{payment.errors.full_messages}"
         puts "[migrate:payments error.row] #{row}"
         puts "[migrate:payments error.quote_id]: #{quote.id}"
         puts "======"
        end
      else
        puts "[migrate:payments error.quote] (data maybe missing) old quote id: #{row[:quote_id]}"
        puts "======="
      end

    end
  end

  # task :charges => :environment do
  #   #id,job_id,created_at,updated_at,data
  #   CSV.foreach("#{Rails.root}/db/migration/charges.csv", {headers: true, header_converters: :symbol, converters: :all}) do |row|
  #     row = row.to_hash
  #
  #       project = Project.where("(data->'migration') @> ?", {id: row[:job_id]}.to_json).first
  #
  #       if project
  #         payments = Payment.where(project_id: project.id)
  #
  #         lead = .create({
  #           first_name: row[:data]['first_name'],
  #           last_name: row[:data]['last_name'],
  #           phone_number: row[:data]['phone'],
  #           meta: row[:data]['meta']
  #         })
  #         unless lead.persisted?
  #          puts "[migrate:leads error] #{lead.errors.full_messages}"
  #         end
  #       else
  #           puts "[migrate:charges error] project not found: #{row[:job_id]}"
  #       end
  #
  #   end
  # end

  task :leads => :environment do
    #id,quote_id,amount,fee_percentage,is_paid,paid_at,payment_summary,
    #created_at,updated_at,reference,due_date,approved,slug,token
    CSV.foreach("#{Rails.root}/db/migration/leads.csv", {headers: true, header_converters: :symbol, converters: :all}) do |row|
      row = row.to_hash
        if row[:data].is_a?(String)
          row[:data] = JSON.parse(row[:data]) rescue nil
        end
        lead = Lead.create({
          first_name: row[:data]['first_name'],
          last_name: row[:data]['last_name'],
          phone_number: row[:data]['phone'],
          meta: row[:data]['meta']
        })
        unless lead.persisted?
          puts "[migrate:leads error.row] #{row}"
          puts "[migrate:leads error] #{lead.errors.full_messages}"
          puts "======"
        end

    end
  end

  task :bot => :environment do
    Account.create(email: 'bot@1roof.com', password: 'password', user_attributes: {type: 'Administrator', profile: {first_name: 'Bot', last_name: 'Roof', phone_number: '1roof.com'}})
  end

  task :fix_project_type => :environment do
    Project.all.map{ |p|
      if p.name.downcase.include?('bathroom')
        p.kind = 'bathroom'
      elsif p.name.downcase.include?('kitchen')
        p.kind = 'kitchen'
      elsif p.name.downcase.include?('extension')
        p.kind = 'extension'
      elsif p.name.downcase.include?('renovation')
        p.kind = 'renovation'
      elsif p.name.downcase.include?('redecoration')
        p.kind = 'redecoration'
      end
      p.save
    }
  end

  task :drop_shortlist => :environment do
    Project.all.map{|p|
      p.professionals_ids = (p.professionals_ids + p.shortlist_ids).uniq
      p.shortlist_ids = []
      p.save
    }
  end

  task :fix_total_amounts => :environment do
    Quote.all.map{|o| o.save(validate: false)}
    Tender.all.map{|o| o.save(validate: false)}
    TenderTemplate.all.map{|o| o.save(validate: false)}
  end



  task :all => [:administrators, :customers, :professionals, :projects, :assets, :shortlists, :tender_templates, :tenders, :quotes, :payments, :leads, :bot, :"jobs:clear"]
end



def parse_tender_data data
  data = data.clone
  {
    sections: data['sections'].map { |sec|
      sec.delete('sectionTotal')

      tasks = data['jobs'] && data['jobs'].select{|j| j['sectionId'] == sec['id']} || []
      materials = data['materials'] && data['materials'].select{|j| j['sectionId'] == sec['id']} || []

      sec['tasks'] = tasks.map { |t|
        t.delete('sectionId')
        rt = {}
        if nt = Task.by_name(t['name']).first || Task.by_action(t['category']).first || Task.by_group(t['category']).first
          rt = nt.data.as_json.clone
          rt.delete('searchable')
          rt['id'] = nt.id
          rt['price'] = (t['unitPrice'].to_i * 100) || 0
          rt['quantity'] = t['quantity'].to_i
          rt['display_name'] = t['name']
        else
          rt = t.clone
          rt['price'] = (t['unitPrice'].to_i * 100) || 0
          rt['quantity'] = t['quantity'].to_i
          rt['action'] = t['category'] || 'Other'
          rt['group'] = 'Other'
          rt['unit'] = 'unitless'
          rt['name'] = rt['name'].to_s
          rt.delete('totalPrice')
          rt.delete('unitPrice')
          rt.delete('category')
        end
        rt
      }
      sec['materials'] = materials.map { |m|
        m.delete('sectionId')
        m['price'] =  (m['unitPrice'].to_i * 100) || 0
        m['quantity'] = m['quantity'].to_i
        m['name'] = m['name'].to_s
        m.delete('unitPrice')
        m
      }
      sec.delete('tasks')  if sec['tasks'].empty?
      sec.delete('materials')  if sec['materials'].empty?
      sec
    }

  }
end
