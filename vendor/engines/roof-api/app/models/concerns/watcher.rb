module Watcher

  extend ActiveSupport::Concern

  module ClassMethods
    def watch callback, actor, action, subject, options = {}
      action ||= callback.to_s.split('_').last
      public_send(callback, options) do
        create_activity eval(actor, get_binding), action, eval(subject, get_binding)
      end
    end
  end

  def create_activity actor, action, subject
    Activity.create(actor: actor, action: action, subject: subject)
  end

  def bot
    @bot ||= Account.find_by(email: 'bot@1roof.com')
  end

  def random_administrator
    Account.where(user_type: 'Administrator').where(id: [6,8]).order('RANDOM()').limit(1)[0]
  end

  def get_binding
   binding
  end

end
