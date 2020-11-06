# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateRateService, type: :service do
  let!(:rate) { Faker::Number.number(digits: 3) }
  let(:time) { (Time.new + 10 * 60).to_s }
  let!(:date) do
    arr = time.split
    arr.delete_at(-1)
    arr.join('T')
  end

  describe 'update rate' do
    context 'when valid params' do

      subject { UpdateRateService.new.call({ rate: rate, date: date }) }

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'is params in redis' do
        subject
        expect(Redis.current.get('date')).to eq time
        expect(Redis.current.get('changed_rate')).to eq rate.to_s
      end
    end

    context 'when invalid params' do

      subject { UpdateRateService.new.call({ rate: 'rate', date: date }) }

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'is params is not redis' do
        subject
        expect(Redis.current.get('changed_rate')).to_not eq 'rate'
      end
    end
  end
end
