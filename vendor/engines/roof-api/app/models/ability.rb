class Ability
  include CanCan::Ability

  def initialize(account, action)
    action = action.try(:to_sym)
    account ||= Account.new # guest

    can [:create, :destroy], Asset
    can [:create], Lead
    can [:accept], Invitation

    if account.administrator?
      can :manage, :all
      can [:index], TenderTemplate
    elsif account.customer?
      can [:manage], Project, ["account_id = ? OR data->'customers_ids' @> ?", account.id, account.id.to_json] do |project|
        project.account_id == account.id || project.customers_member?(account)
      end

      can [:show, :update], Customer, account_id: account.id

      can [:read, :update], Appointment, attendant_id: account.user_id
      can [:read, :update], Appointment, host_id: account.user_id
      can [:create, :destroy], Appointment, host_id: account.user_id, host_type: account.user_type

      can [:read], Task
      can [:read], Material

      can [:create, :read, :update], Tender, Tender.accessible_through_project_by(account) do |tender|
        tender.project.account_id == account.id || tender.project.customers_member?(account)
      end
      can [:read, :accept], Quote, Quote.is_submitted.accessible_through_project_by(account) do |quote|
        quote.project.account_id == account.id || quote.project.customers_member?(account)
      end
      can [:read, :pay], Payment, Payment.is_approved.accessible_through_project_by(account) do |payment|
        payment.project.account_id == account.id || payment.project.customers_member?(account)
      end
      can [:invite], Invitation, inviter_id: account.id
      can :manage, Comment

    elsif account.professional?
      can [:manage], Project, ["account_id = ? OR data->'professionals_ids' @> ?", account.id, account.id.to_json] do |project|
        project.account_id == account.id ||
        project.professionals_member?(account)
      end

      can [:show, :update], Professional, account_id: account.id

      can [:read, :update], Appointment, host_id: account.user_id
      can [:read, :update], Appointment, attendant_id: account.user_id
      can [:create, :destroy], Appointment, host_id: account.user_id, host_type: account.user_type

      can [:read], Task
      can [:read], Material
      can [:read], Tender, Tender.accessible_through_project_by(account) do |tender|
        tender.project.account_id == account.id ||
        tender.project.professionals_member?(account)
      end
      can [:manage, :submit], Quote, professional_id: account.user_id
      can [:create, :read, :update, :cancel, :submit], Payment, professional_id: account.user_id

      can [:invite], Invitation, inviter_id: account.id
      can :manage, Comment
      can [:index], TenderTemplate
    end
  end
end
