require 'validators/json_schema_validator'

class StripeAccount < StripeUser

  attr_accessor :id, :updates

  ACCOUNT_SCHEMA = {
    type: 'object',
    properties: {
      business_logo: { type: 'string' },
      business_name: { type: 'string' },
      business_primary_color: { type: 'string' },
      business_url: { type: 'string' },
      debit_negative_balances: {
        type: 'boolean',
        description: 'see https://stripe.com/docs/connect/bank-transfers#negative-balances'
      },
      decline_charge_on: {
        type: 'object',
        properties: {
          avs_failure: { type: 'boolean' },
          cvc_failure: { type: 'boolean' }
        }
      },
      default_currency: { type: 'string' },
      email: { type: 'string' },
      external_account: {
        type: 'object',
        properties: {
          object: { type: 'string' },
          account_number: { type: 'string' },
          country: { type: 'string' },
          currency: { type: 'string' },
          account_holder_name: { type: 'string' },
          account_holder_type: { type: 'string' },
          routing_number: { type: 'string' }
        },
        required: ['object', 'account_number', 'country', 'currency']
      },
      legal_entity: {
        type: 'object',
        properties: {
          additional_owners: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                address: {
                  type: 'object',
                  properties: {
                    city: { type: 'string' },
                    country: { type: 'string' },
                    line1: { type: 'string' },
                    line2: { type: 'string' },
                    postal_code: { type: 'string' },
                    state: { type: 'string' }
                  }
                },
                dob: {
                  type: 'object',
                  properties: {
                    day: { type: 'string' },
                    month: { type: 'string' },
                    year: { type: 'string' }
                  },
                  required: ['day', 'month', 'year']
                },
                first_name: { type: 'string' },
                last_name: { type: 'string' },
                verification: {
                  type: 'object',
                  properties: {
                    document: {
                      type: 'string' ,
                      description: 'An ID returned by a file upload with the purpose ‘identity_document’. See https://stripe.com/docs/api#list_file_uploads'
                    }
                  }
                }
              }
            }
          },
          address: {
            type: 'object',
            properties: {
              city: { type: 'string' },
              country: { type: 'string' },
              line1: { type: 'string' },
              line2: { type: 'string' },
              postal_code: { type: 'string' },
              state: { type: 'string' }
            }
          },
          business_name: { type: 'string' },
          business_tax_id: { type: 'string' },
          business_vat_id: { type: 'string' },
          dob: {
            type: 'object',
            properties: {
              day: { type: 'string' },
              month: { type: 'string' },
              year: { type: 'string' }
            },
            required: ['day', 'month', 'year']
          },
          first_name: { type: 'string' },
          last_name: { type: 'string' },
          gender: { enum: ['male', 'female'] },
          maiden_name: { type: 'string' },
          personal_address: {
            type: 'object',
            properties: {
              city: { type: 'string' },
              country: { type: 'string' },
              line1: { type: 'string' },
              line2: { type: 'string' },
              postal_code: { type: 'string' },
              state: { type: 'string' }
            }
          },
          personal_id_number: { type: 'string' },
          phone_number: { type: 'string' },
          type: { enum: ['individual', 'company'] },
          verification: {
            type: 'object',
            properties: {
              document: {
                type: 'string' ,
                description: 'An ID returned by a file upload with the purpose ‘identity_document’. See https://stripe.com/docs/api#list_file_uploads'
              }
            }
          },
          tos_acceptance: {
            type: 'object',
            properties: {
              date: {type: 'string'},
              ip: {type: 'string'},
              user_agent: {type: 'string'}
            },
            required: ['date', 'ip']
          },
          transfer_schedule: {
            type: 'object',
            properties: {
              delay_days: {type: 'string'},
              interval: {enum: ['daily', 'weekly', 'monthly']},
              monthly_anchor: {type: 'integer'},
              weekly_anchor: {enum: ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']},
            }
          }
        }
      }
    }
  }

  validates :updates, json_schema: {schema: ACCOUNT_SCHEMA}, if: 'updates.present?'

  def initialize attributes = {}
    super
    if updates.try(:[],:legal_entity).try(:[],:additional_owners) && updates[:legal_entity][:additional_owners].is_a?(Hash)
      updates[:legal_entity][:additional_owners] = updates[:legal_entity][:additional_owners].sort.map{|k,v| v}
    end
  end

  def create
    # don't create another customer if already exists
    errors.add(:id, :taken) and return self if self.id.present?

    @object, error = with_stripe_error_handlers do
      Stripe::Account.create({
          :country => "GB",
          :managed => true
      })
    end
    if error.nil?
      self.id = object.id
    else
      errors.add(:id, error)
    end
    self
  end

  def attributes
    {id: nil}
  end

  def update

    if valid?
      @object = nil

      if (identity_document = updates.try(:[], :legal_entity).try(:delete, :identity_document)).present?

        document_id, error = stripe_upload_file('identity_document', identity_document)

        unless error
          updates[:legal_entity] ||= {}
          updates[:legal_entity][:verification] = {:document => document_id}
          puts "legal_entity #{updates[:legal_entity]}"
        else
          errors.add(:"updates.identity_document", error)
          return false
        end
      end

      saved, error = with_stripe_error_handlers do

        if object.try(:verification).try(:fields_needed).include?('tos_acceptance.date') ||
          object.try(:verification).try(:fields_needed).include?('tos_acceptance.ip')
          updates[:tos_acceptance] = {ip: RequestStore.store[:ip].to_s, date: Time.now.to_i}
        end

        if (external_account = updates.delete(:external_account))
          object.external_accounts.create(external_account: external_account)
        end

        if (updates.try(:[],:legal_entity).try(:[],:additional_owners))
          updates[:legal_entity][:additional_owners].each_with_index{ |owner, i|
            if identity_document = owner.delete(:identity_document)
              document_id, error = stripe_upload_file('identity_document', identity_document)
              if document_id
                updates[:legal_entity][:additional_owners][i][:verification] ||= {}
                updates[:legal_entity][:additional_owners][i][:verification][:document] = document_id
              else
                errors.add(:"updates.legal_entity.additional_owners.#{i}.identity_document", error)
              end
            end
          }
        end
        update_recursive object, updates
        # object.update_attributes(updates)
        object.save

        object
      end
      unless error.nil?
        errors.add(:updates, error)
        false
      end
    end
  end


end
