# frozen_string_literal: true

require 'sidekiq-scheduler'
# require 'net/http'

class CheckCurrencyJob
  include Sidekiq::Worker

  def perform
    result = Net::HTTP.get(URI(ENV['EXCHANGE_RATES']))
    value = JSON.parse(result)['Valute']['USD']['Value'].to_s

    Redis.current.set('current_course', value)
  end
end
