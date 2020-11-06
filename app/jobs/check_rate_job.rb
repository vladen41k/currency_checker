# frozen_string_literal: true

require 'sidekiq-scheduler'
# require 'net/http'

class CheckRateJob
  include Sidekiq::Worker

  def perform
    CheckRateService.new.call
  end
end
