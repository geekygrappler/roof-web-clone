require 'slack-notifier'

class Activity < ActiveRecord::Base

  NOTIFICATIONS = HashWithIndifferentAccess.new(YAML.load(File.read("config/notifications.yml"))).freeze
  WEBHOOK_URL = "https://hooks.slack.com/services/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".freeze

  belongs_to :actor, polymorphic: true
  belongs_to :subject, polymorphic: true
  store_accessor :data, :action, :description
  before_create :set_description
  after_create :notify

  private

  def set_description
    verb = action.dup.verb.conjugate tense: :past, aspect: :perfective
    self.description = "#{actor.try(:to_s)} #{verb} #{subject.try(:to_s)}"
  end

  def notify
    # notify slack regardless user notification settings
    notify_slack

    # check recipients notification settings and if there is any notify them
    # however, only not channel is email for this atm
    if notifications = NOTIFICATIONS[subject.class.name.downcase].try(:[], action) ||  NOTIFICATIONS[actor.class.name.downcase].try(:[], action)
        notifications.each do |notification|
          params = notification.dup
          params[:from] = eval(params[:from], get_binding)
          params[:to] = eval(params[:to], get_binding)
          params[:subject] = subject
          params[:actor] = actor
          params[:action] = action
          if params[:to].is_a?(ActiveRecord::Relation)
            params[:to].each do |to|
              notify_mailer(params.merge(to: to))
            end
          else
            notify_mailer(params)
          end
        end
      end
  end

  def notify_mailer params
    if params[:to].notify_for?(params[:name])
      ActivityMailer.notify(params).public_send(params[:deliver_now] ? :deliver_now : :deliver_later)
    end
  end

  def notify_slack
    if actor.class == subject.class && actor.id == subject.id
      params = {
        action: action,
        subject_class: subject.class.name,
        subject: subject.as_json,
      }
    else
      params = {
        actor_class: actor.class.name,
        actor: actor.as_json,
        action: action,
        subject_class: subject.class.name,
        subject: subject.as_json,
      }
    end
    ping = slack_notifier.ping Slack::Notifier::LinkFormatter.format("new activity: ```#{JSON.pretty_generate params.as_json}```")
  end

  def slack_notifier
    @slack_notifier ||= Slack::Notifier.new(WEBHOOK_URL, channel: "#activities", username: 'webhookbot')
  end
end
