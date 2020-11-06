# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

class UpdateRateService
  include Dry::Monads[:result, :try]
  include Dry::Monads::Do.for(:call)

  def call(params)
    valid_params = yield validate(params)
    update_status = yield update(valid_params)
    result = yield return_result(update_status[:result_rate], update_status[:result_date])

    Success(result)
  end

  def validate(params)
    res = UpdateRateValidation.new.call(params.to_h)

    res.success? ? Success(res) : Failure(res)
  end

  def update(params)
    Try do
      result_rate = Redis.current.set('changed_rate', params[:rate].to_s)
      result_date = Redis.current.set('date',  params[:date].to_s)

      { result_rate: result_rate, result_date: result_date }
    end.to_result
  end

  def return_result(result_rate, result_date)
    if result_rate == 'OK' && result_date == 'OK'
      Success('rate successfully update')
    elsif result_rate == 'OK'
      Failure('rate not update')
    else
      Failure('date not update')
    end
  end
end
