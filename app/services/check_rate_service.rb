# frozen_string_literal: true

class CheckRateService

  def call
    date = Redis.current.get('date')
    return if date.present? && date.to_time > Time.now

    result = Net::HTTP.get(URI(ENV['EXCHANGE_RATES']))
    value = JSON.parse(result)['Valute']['USD']['Value'].to_s
    Redis.current.set('current_rate', value)
    ActionCable.server.broadcast('rate', value: value)
  end
end
