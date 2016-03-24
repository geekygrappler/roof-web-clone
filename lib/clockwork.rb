require 'clockwork'
require './config/boot'
require './config/environment'
require 'notify'

module Clockwork

  PARAMS_NOTIFICATIONS = Rails.env.development? ?
    [10.minute, 'notify.job'] :
    [1.day, 'notify.job', at: '09:00']

  configure do |config|
    # config[:sleep_timeout] = 5
    config[:logger] = Logger.new(STDOUT)
    config[:tz] = 'GMT'
    # config[:max_threads] = 15
    # config[:thread] = true
  end

  # handler receives the time when job is prepared to run in the 2nd argument
  handler do |job, time|
    puts "Running #{job}, at #{time}"
  end

  every(*PARAMS_NOTIFICATIONS) {
    Notify.create_activities
  }

end
