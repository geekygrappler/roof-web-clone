class Stat < ActiveRecord::Base
  belongs_to :stat_type
  belongs_to :statable, polymorphic: true
  belongs_to :referenceable, polymorphic: true

  class << self
    def set(type_key, opts={})
      stat = get_stat(type_key, opts)
      lib = "Statistics::#{type_key.to_s.classify}".constantize
      val = lib.calc(opts)
      stat.value = val
      stat.save
      val
    end

    def get(type_key, opts={})
      stat = get_stat(type_key, opts)
      lib = "Statistics::#{type_key.to_s.classify}".constantize
      lib.val(stat)
    end

    private

    def get_stat(type_key, opts={})
      stat_type = StatType.where(name: type_key.to_s).first_or_create
      stat_type.stats.where(
          statable_type: opts[:statable].class, statable_id: opts[:statable].try(:id),
          referenceable_type: opts[:referenceable].class, referenceable_id: opts[:referenceable].try(:id)
      ).first_or_initialize
    end
  end
end
