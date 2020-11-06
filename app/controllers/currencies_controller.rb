# frozen_string_literal: true

class CurrenciesController < ApplicationController

  def index
    @rate = if Redis.current.get('date').present? &&
               Redis.current.get('date').to_time > Time.now &&
               Redis.current.get('changed_rate').present?
              Redis.current.get('changed_rate')
            else
              Redis.current.get('current_rate')
            end
  end

end
