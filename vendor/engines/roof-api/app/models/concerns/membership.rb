# provides has_many like functionalty through {membership}_ids field
module Membership
  extend ActiveSupport::Concern

  module ClassMethods
    def membership *ids_attributes
      @membership ||= begin
        ids_attributes.each do |group|
          class_eval <<-RUBY
            def #{group}
              Account.where(id: #{group}_ids)
            end

            def add_to_#{group} account_or_id, save = false
              id = id_of(account_or_id)
              ids = self.#{group}_ids || []
              ids.push id unless ids.include?(id)
              self.#{group}_ids = ids
              self.save if save
            end

            def remove_from_#{group} account_or_id, save = false
              id = id_of(account_or_id)
              ids = self.#{group}_ids || []
              ids.delete id
              self.#{group}_ids = ids
              self.save if save
            end

            def #{group}_member? other_account_or_id
              self.#{group}_ids.include? id_of(other_account_or_id)
            end
          RUBY
        end
        ids_attributes
      end
    end
  end

  included do
    after_initialize :ensure_memberhip_group_arrays
  end

  def member? other_account_or_id
    self.class.membership.map{ |group|
      public_send("#{group}_member?", other_account_or_id)
    }.include?(true)
  end

  private

  def id_of object
    object.is_a?(Account) ? object.id :
    (object.respond_to?(:account) ? object.account.id : object.to_i)
  end

  def ensure_memberhip_group_arrays
    self.class.membership.each do |group|
      self.public_send("#{group}_ids=", self.public_send("#{group}_ids") || [])
    end
  end

end
