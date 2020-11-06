# frozen_string_literal: true

class UpdateRateValidation < Dry::Validation::Contract
  params do
    required(:rate).filled(:integer)
    required(:date).filled(:time)
  end

  rule(:date) do
    key.failure('must be greater than the current date') if value <= Time.new
  end
end
