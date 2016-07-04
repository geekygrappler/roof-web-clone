class TimeInFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :time_past) if value && value < DateTime.now #&& (time_was.nil? || time_changed?)
  end
end
