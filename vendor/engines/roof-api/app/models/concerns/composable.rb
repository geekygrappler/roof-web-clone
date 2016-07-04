module Composable

  extend ActiveSupport::Concern

  class Model
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON
    def initialize attributes = {}
      super
      @serializable_attributes = Hash[(attributes || {}).map{|k,v| [k,nil]}]
    end
    def attributes
      @serializable_attributes
    end
  end

  module ClassMethods
    def composable_classes
      @composable_classes
    end
    def composables *composables
      @composables ||= begin
        @composable_classes ||= {}
        composables.map! do |composable|
          options = nil
          if composable.is_a?(Hash)
            options = composable.values.first
            composable = composable.keys.first
          end
          klass = (options && options[:class_name] ? options[:class_name] : composable.to_s.classify)
          @composable_classes[composable] = klass
          define_method(composable) {
            instance_variable_get("@#{composable}") ||
              instance_variable_set("@#{composable}",
                klass.constantize.new(data["#{composable}_attributes"])
              )
          }

          # merge the data instead of replacing it
          define_method("#{composable}=") { |composable_attributes|
            # instance_variable_set("@#{composable}", nil)
            instance_variable_set("@#{composable}",
              self.class.composable_classes[:"#{composable}"].constantize.new((data["#{composable}_attributes"] ||= {}).merge(composable_attributes))
            )
            # (data["#{composable}_attributes"] ||= {}).update(composable_attributes)
          }

          composable
        end
        # composables
      end
    end

  end

  included do
    before_save :write_composables_attributes
  end

  # NOTE: default: {} add  in sql to get rid of this but
  # still needed to make it robust as data attribute can be set to nil somehow
  def data
    read_attribute(:data) || (write_attribute(:data, {}) && read_attribute(:data))
  end

  def valid? context = nil
    self_valid = super
    all_composables_valid = !self.class.composables.map{ |composable| public_send(composable).valid? }.include?(false)
    self_valid && all_composables_valid
  end

  def errors
    base_errors = super
    self.class.composables.each { |composable|
      public_send(composable).errors.messages.each do |field, messages|
        messages.each do |message|
          base_errors.add "#{composable}.#{field}", message
        end
      end
    }
    base_errors
  end

  private

  def write_composables_attributes
    self.class.composables.each { |composable|
      # public_send("#{composable}=", public_send(composable).as_json)
      data["#{composable}_attributes"] = public_send(composable).as_json
    }
  end

end
