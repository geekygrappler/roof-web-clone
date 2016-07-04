module BooleanAt
  extend ActiveSupport::Concern
  module ClassMethods
    def boolean_at *attrs
      @boolean_at ||= begin
        attrs.each do |attr_name|
          scope :"is_#{attr_name}", -> { where("#{table_name}.data ? :attr_name", {attr_name: "#{attr_name}_at"}) }
          scope :"not_#{attr_name}", -> { where.not("#{table_name}.data ? :attr_name", {attr_name: "#{attr_name}_at"}) }
          define_method("#{attr_name}?") do
            !!public_send("#{attr_name}_at")
          end
        end
        attrs
      end
    end
  end
end
