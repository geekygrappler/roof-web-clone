module Accountable
  extend ActiveSupport::Concern

  module ClassMethods
    def aggregate_prices task_id = nil, professional_id = nil
      where = task_id ? "WHERE task.id = #{task_id}" : nil
      where = (task_id ? "#{where} AND professional_id = #{professional_id}" : "WHERE professional_id = #{professional_id}") if professional_id
      ActiveRecord::Base.connection.execute(%Q{
        SELECT DISTINCT(task.id) as id,
          COUNT(task.price) as count,
          MIN(task.price) as min_rate,
          MAX(task.price) as max_rate,
          AVG(task.price) as avg_rate
        FROM #{table_name},
        jsonb_to_recordset(#{table_name}.data -> 'document_attributes' -> 'sections') AS section(name varchar, tasks jsonb, materials jsonb),
        jsonb_to_recordset(section.tasks) AS task(id int, action varchar, name varchar, quantity int, unit varchar, price int)
        #{where}
        GROUP BY task.id
      })
    end

    def last_price task_id = nil, professional_id = nil
      where = task_id ? "WHERE task.id = #{task_id}" : nil
      where = (task_id ? "#{where} AND professional_id = #{professional_id}" : "WHERE professional_id = #{professional_id}") if professional_id
      ActiveRecord::Base.connection.execute(%Q{
        SELECT quotes.id as qid, task.id as id, task.price as price
        FROM #{table_name},
        jsonb_to_recordset(#{table_name}.data -> 'document_attributes' -> 'sections') AS section(name varchar, tasks jsonb, materials jsonb),
        jsonb_to_recordset(section.tasks) AS task(id int, action varchar, name varchar, quantity int, unit varchar, price int)
        #{where}
        ORDER BY created_at DESC
        LIMIT 1
      })
    end

    def pro_and_roof_prices task_id = nil, professional_id = nil
      where = task_id ? "WHERE task.id = #{task_id}" : nil
      where = (task_id ? "#{where} AND quotes.professional_id = #{professional_id}" : "WHERE quotes.professional_id = #{professional_id}") if professional_id
      pro_prices = ActiveRecord::Base.connection.execute(%Q{
        SELECT quotes.id as qid, quotes.professional_id as pid, task.id as id, task.price as price, task.quantity as quantity, task.action as action, task.name as name, task.display_name as display_name
        FROM #{table_name},
        jsonb_to_recordset(#{table_name}.data -> 'document_attributes' -> 'sections') AS section(name varchar, tasks jsonb, materials jsonb),
        jsonb_to_recordset(section.tasks) AS task(id int, action varchar, name varchar, display_name varchar, quantity int, unit varchar, price int)
        #{where}
        ORDER BY created_at DESC
      })
      pro_prices.to_a.map{ |task|
        if task['id']
          roof_task = Task.find(task['id'].to_i)
          task['professional_name'] = Professional.find(task['pid']).profile.full_name
          task['roof_task.name'] = roof_task.name
          task['roof_task.price'] = roof_task.price
          task['roof_task.action'] = roof_task.action
        end
        task
      }
    end

  end

  included do
    store_accessor :data, :total_amount
    include Composable
    composables document: {class_name: 'TenderDocument'}

    before_save :document_create_all_new_items
    before_save :set_total_amount
    delegate :create_all_new_items, to: :document, prefix: true
  end

  private

  def set_total_amount
    self.total_amount = document.total
  end
end
