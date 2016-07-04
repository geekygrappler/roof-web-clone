require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  setup do
    @project=projects(:one)
    @customer = accounts(:acc_custom)
    @admin = accounts(:acc_admin)
    @customer_invitee_attributes = {
      user_type: 'Customer',
      email: 'invc@email.com'
    }
    @pro_invitee_attributes = {
      user_type: 'Professional',
      email: 'invp@email.com'
    }
  end
  test "invitable customer" do
    invitation = Invitation.invite @project.id, @customer.id, @customer_invitee_attributes
    assert invitation
    invitation = Invitation.accept(invitation.token, {password: 'password',
      user_attributes: {
        profile: {
          first_name: 'lala',
          last_name: 'lala',
          phone_number: 'lala'
        }
      }
    })
    assert invitation
    assert invitation.project.customers_member?(invitation.invitee)
  end
  test "invitable pro" do
    invitation = Invitation.invite @project.id, @customer.id, @pro_invitee_attributes
    assert invitation
    invitation = Invitation.accept(invitation.token, {password: 'password',
      user_attributes: {
        profile: {
          first_name: 'lala',
          last_name: 'lala',
          phone_number: 'lala'
        }
      }
    })
    assert invitation
    assert invitation.project.professionals_member?(invitation.invitee)
  end
  test "invitable admin" do
    invitation = Invitation.invite @project.id, @admin.id, @pro_invitee_attributes
    assert invitation
    invitation = Invitation.accept(invitation.token, {password: 'password',
      user_attributes: {
        profile: {
          first_name: 'lala',
          last_name: 'lala',
          phone_number: 'lala'
        }
      }
    })
    assert invitation
    assert invitation.project.professionals_member?(invitation.invitee)
  end
end
