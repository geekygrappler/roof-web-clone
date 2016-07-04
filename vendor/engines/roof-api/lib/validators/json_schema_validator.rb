class JsonSchemaValidator < ActiveModel::EachValidator
  def initialize(options)
    super
    @schema = options[:schema]
    @validator_options = (options[:options] || {}).update({validate_schema: true})
  end
  def validate_each(record, attribute, value)
    json_errors = JSON::Validator.fully_validate(@schema, value, @validator_options)
    if has_errors = json_errors.any?
      json_errors.each do |error|
        record.errors.add(attribute, error)
      end
    end
    has_errors
  end
end
