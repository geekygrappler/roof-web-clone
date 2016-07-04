require 'validators/json_schema_validator'
class TenderDocument < Composable::Model

  VAT = 20

  TASK_SCHEMA = {
    type: "object",
    properties: {
      id: {
        type: "integer",
        description: "Master task id, empty if task item is brand new"
      },
      action: {
        type: "string"
      },
      group: {
        type: "string"
      },
      name: {
        type: "string",
        description: "Name of the Task Item, eg: Head units"
      },
      quantity: {
        type: "integer",
        description: "Quantity of task item, meaningful with unit property"
      },
      unit: {
        enum: Task::UNITS,
        description: "Measurable unit. Can be unitless, meter, square meter or cubic meter"
      },
      dimensions: {
        type: "array",
        description: "Dimensions"
      },
      price: {
        type: "integer",
        description: "Rate for task item in pounds"
      },
      description: {
        type: "string",
        description: "Item's Description"
      }
    },
    required: ["action", "group", "name", "quantity", "unit", "price"]
  }

  MATERIAL_SCHEMA = {
    type: "object",
    properties: {
      id: {
        type: "integer",
        description: "Master material id, empty if material item is brand new"
      },
      name: {
        type: "string",
        description: "Name of the Material Item, eg: lights"
      },
      quantity: {
        type: "integer",
        description: "Quantity of material item"
      },
      price: {
        type: "integer",
        description: "Unit price of material item in pounds"
      },
      supplied: {
        type: "boolean",
        description: "Is Supplied is true if materials supplied by professional"
      },
      description: {
        type: "string",
        description: "Item's Description"
      }
    },
    required: ["name", "quantity", "price", "supplied"]
  }

  SECTION_SCHEMA = {
    type: "array",
    items: {
      type: "object",
      properties: {
        id: {
          type: "integer",
          description: "section index as ID"
        },
        name: {
          type: "string",
          description: "The name of the section, eg: Kitchen"
        },
        dimensions: {
          type: "array",
          description: "Room dimensions"
        },
        tasks: {
          type: "array",
          items: TASK_SCHEMA,
          minItems: 1
        },
        materials: {
          type: "array",
          items: MATERIAL_SCHEMA,
          minItems: 1
        }
      },
      required: ["name"]
    },
    minItems: 1
  }

  SCHEMA = {
    type: "object",
    properties: {
      sections: SECTION_SCHEMA
    }
  }

  attr_accessor :sections, :include_vat

  validates :sections, presence: true
  validates :sections, json_schema: {schema: TenderDocument::SCHEMA, options: {fragment: '#/properties/sections'}}

  def initialize attributes = {}
    attributes = HashWithIndifferentAccess.new(attributes)
    super
    typecast if valid?
    self.sections ||= []
  end

  def total
    subtotal + vat
  end

  def subtotal
    tasks_total + materials_total
  end

  def vat
    include_vat ? tasks_total * VAT / 100 : 0
  end

  def section_total name
    sections.select{ |sec| sec['name'] == name }
    .inject(0){ |sum, sec|
      sum + tasks_total(sec['tasks']) + materials_total(sec['materials'])
    }
  end

  def tasks_total tasks = nil
    (tasks || items('tasks')).inject(0){ |sum, item|
      sum + (item['quantity'] * item['price'])
    }
  end

  def materials_total materials = nil
    (materials || items('materials')).inject(0){ |sum, item|
      sum + (item['supplied'] ? item['quantity'] * item['price'] : 0)
    }
  end

  def items name
    sections.map{ |sec| sec[name] }.flatten.compact
  end

  def new_items name
    sections.map{ |sec| sec[name] }.flatten.compact
    .keep_if{ |item| item['id'].nil? }
  end

  def create_all_new_items
    create_new_items 'tasks'
    create_new_items 'materials'
  end

  def create_new_items name
    new_items(name).map!{ |item|
      klass = name.classify.constantize
      params = item_search_params(name, item)
      item.delete('display_name')
      item.delete('description')
      dbitem = klass.where("data @> ?", params.to_json).first || klass.create(clone_item(item))
      item['id'] = dbitem.id
      item
    }
  end

  def item_search_params name, item
    if name == 'tasks'
      params = {
        name: item['name'],
        action: item['action'],
        group: item['group']
      }
    else
      params = {
        name: item['name']
      }
    end
  end

  def typecast
    ['tasks', 'materials'].each do |name|
      items(name).map! do |item|
        item['price'] = item['price'].to_i
        item['quantity'] = item['quantity'].to_i
        if item['id']
          item['id'] = item['id'].to_i
        else
          item.delete('id')
        end
        item
      end
    end
  end

  private

  def clone_item item
    item = item.clone
    item['price'] = item['price'] / 100
    item
  end

end
