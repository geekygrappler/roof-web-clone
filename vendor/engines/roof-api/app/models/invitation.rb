class Invitation < ActiveRecord::Base
  belongs_to :project, required: true, validate: true
  belongs_to :inviter, required: true, validate: true, class_name: 'Account'
  belongs_to :invitee, class_name: 'Account'
  store_accessor :data,
    :token,
    :invitee_attributes,
    :invited_at,
    :accepted_at

  validate :validate_invitee_attributes, on: :create
  validate :validate_project
  before_create :generate_token

  scope :search, ->(query) { where('data::text ilike ?', "%#{query}%")}

  def self.invite project_id, inviter_id, invitee_attributes
    if account = Account.find_by(email: invitee_attributes['email'], user_type: invitee_attributes['user_type'])
      invitation = create(inviter_id: inviter_id, project_id: project_id, invitee_attributes: invitee_attributes)
      if invitation.persisted?
        invitation.accept(account)
      end
      invitation
    else
      invitation = create(inviter_id: inviter_id, project_id: project_id, invitee_attributes: invitee_attributes)
      if invitation.persisted?
        if InvitationMailer.invite(invitation).deliver_later
          invitation.update(invited_at: DateTime.now)
        end
      end
      invitation
    end
  end

  ##
  # invitee_attributes: [:password, {user_attributes: [$profile_attributes]}]
  def self.accept token, invitee_attributes
    Invitation.transaction do
      begin
        if invitation = find_by("data->'token' = ?", token.to_json)
        account = Account.create({
          email: invitation.invitee_attributes['email'],
          password: invitee_attributes.delete('password'),
          user_attributes: invitee_attributes.merge({
            type: invitation.invitee_attributes['user_type']
          })
        })
        if account.persisted?
          invitation.accept(account)
        end

        invitation
      end
      rescue Exception => e
        Rails.logger.error e.inspect + "\n" + e.backtrace.join("\n")
        raise ActiveRecord::Rollback
      end
    end
  end

  def accept account
    self.invitee = account
    if account.customer?
      self.project.add_to_customers(account)
    else
      self.project.add_to_professionals(account)
    end
    if self.project.save
      self.update(invitee: account, accepted_at: DateTime.now)
    end
  end

  private

  def generate_token
    self.token = Devise.friendly_token[0, 8]
  end

  def validate_project
    if project
      if inviter.user.is_a?(Customer) && !project.customers_member?(inviter) ||
         inviter.user.is_a?(Professional) && !(project.professionals_member?(inviter))

         errors.add(:project, "is not accessible")
      end
    end
  end

  def validate_invitee_attributes
    errors.add(:'invitee_attributes.email', 'cannot be blank') unless invitee_attributes['email'].present?
    errors.add(:'invitee_attributes.user_type', 'cannot be blank') unless invitee_attributes['user_type'].present?
  end

end
