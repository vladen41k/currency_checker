class RateChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'rate'
  end
end
