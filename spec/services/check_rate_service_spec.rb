# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckRateService, type: :service do

  describe 'update rate' do
    context 'when happens request' do

      before do
        stub_request(:get, 'https://www.cbr-xml-daily.ru/daily_json.js')
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host' => 'www.cbr-xml-daily.ru',
              'User-Agent' => 'Ruby'
            }
          )
          .to_return(status: 200, body: '{"Date": "2020-11-06T11:30:00+03:00",
                                          "PreviousDate": "2020-11-04T11:30:00+03:00",
                                          "PreviousURL": "\/\/www.cbr-xml-daily.ru\/archive\/2020\/11\/04\/daily_json.js",
                                          "Timestamp": "2020-11-05T23:00:00+03:00",
                                          "Valute": { "USD": {
                                                  "ID": "R01235",
                                                  "NumCode": "840",
                                                  "CharCode": "USD",
                                                  "Nominal": 1,
                                                  "Name": "Доллар США",
                                                  "Value": 178.4559,
                                                  "Previous": 80.0006
                                                                        }}}', headers: {})
      end

      subject do
        CheckRateService.new.call
      end

      it 'is successful' do
        subject
        expect(Redis.current.get('current_rate')).to eq '178.4559'
      end

    end
  end
end
