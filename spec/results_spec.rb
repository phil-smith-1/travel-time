require 'spec_helper'
require_relative '../models/init'

RSpec.describe Result, type: :model do
  let(:params) do
    {
      'start_date_time' => '2017-03-19T20:00',
      'postcodes' => [
        'E1 6LA',
        'EC1M 5RS',
        'NW1 0AG',
        'M2 5BG'
      ],
      'appointment_durations' => [
        '45',
        '34',
        '15',
        '60'
      ]
    }
  end

  let(:expected_full_data) do
    [
      {
        postcode: 'EC1A 9HF',
        appointment_duration: 0,
        latitude: 51.5199746402298,
        longitude: -0.0984090718153747,
        skip: false,
        departure_date_time: Time.parse('2017-03-19 20:00:00 +0000')
      },
      {
        postcode: 'E1 6LA',
        appointment_duration: 45,
        latitude: 51.5242316254431,
        longitude: -0.0738260998538828,
        skip: false,
        arrival_date_time: Time.parse('2017-03-19 20:15:00 +0000'),
        travel_time_minutes: 15,
        departure_date_time: Time.parse('2017-03-19 21:00:00 +0000')
      },
      {
        postcode: 'EC1M 5RS',
        appointment_duration: 34,
        latitude: 51.5224276452689,
        longitude: -0.103842249440472,
        skip: false,
        arrival_date_time: Time.parse('2017-03-19 21:25:00 +0000'),
        travel_time_minutes: 25,
        departure_date_time: Time.parse('2017-03-19 21:59:00 +0000')
      },
      {
        postcode: 'NW1 0AG',
        appointment_duration: 15,
        latitude: 51.5377718268226,
        longitude: -0.14053750103839,
        skip: false,
        arrival_date_time: Time.parse('2017-03-19 22:34:00 +0000'),
        travel_time_minutes: 35,
        departure_date_time: Time.parse('2017-03-19 22:49:00 +0000')
      }
    ]
  end

  subject { Result.new(params) }

  before do
    stub_request(:get, 'http://api.postcodes.io/postcodes/EC1A%209HF')
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'api.postcodes.io', 'User-Agent' => 'HTTP Client API/1.0' })
      .to_return(status: 200, body: "{\"result\":{\"longitude\":-0.0984090718153747,\"latitude\":51.5199746402298,\"region\":\"London\"}}", headers: {})
    stub_request(:get, 'http://api.postcodes.io/postcodes/E1%206LA')
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'api.postcodes.io', 'User-Agent' => 'HTTP Client API/1.0' })
      .to_return(status: 200, body: "{\"result\":{\"longitude\":-0.0738260998538828,\"latitude\":51.5242316254431,\"region\":\"London\"}}", headers: {})
    stub_request(:get, 'http://api.postcodes.io/postcodes/EC1M%205RS')
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'api.postcodes.io', 'User-Agent' => 'HTTP Client API/1.0' })
      .to_return(status: 200, body: "{\"result\":{\"longitude\":-0.103842249440472,\"latitude\":51.5224276452689,\"region\":\"London\"}}", headers: {})
    stub_request(:get, 'http://api.postcodes.io/postcodes/NW1%200AG')
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'api.postcodes.io', 'User-Agent' => 'HTTP Client API/1.0' })
      .to_return(status: 200, body: "{\"result\":{\"longitude\":-0.14053750103839,\"latitude\":51.5377718268226,\"region\":\"London\"}}", headers: {})
    stub_request(:get, 'http://api.postcodes.io/postcodes/M2%205BG')
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'api.postcodes.io', 'User-Agent' => 'HTTP Client API/1.0' })
      .to_return(status: 200, body: "{\"result\":{\"longitude\":-2.2470971726518,\"latitude\":53.4782028622593,\"region\":\"North West\"}}", headers: {})

    stub_request(:get, "https://developer.citymapper.com/api/1/traveltime/?endcoord=51.5242316254431,-0.0738260998538828&key=&startcoord=51.5199746402298,-0.0984090718153747&time=2017-03-19T20:00:00%2000:00&time_type=arrival")
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'developer.citymapper.com', 'User-Agent' => 'HTTP Client API/1.0' })
      .to_return(status: 200, body: "{\"travel_time_minutes\":15}", headers: {})
    stub_request(:get, "https://developer.citymapper.com/api/1/traveltime/?endcoord=51.5224276452689,-0.103842249440472&key=&startcoord=51.5242316254431,-0.0738260998538828&time=2017-03-19T21:00:00%2000:00&time_type=arrival")
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'developer.citymapper.com', 'User-Agent' => 'HTTP Client API/1.0' })
      .to_return(status: 200, body: "{\"travel_time_minutes\":25}", headers: {})
    stub_request(:get, "https://developer.citymapper.com/api/1/traveltime/?endcoord=51.5377718268226,-0.14053750103839&key=&startcoord=51.5224276452689,-0.103842249440472&time=2017-03-19T21:59:00%2000:00&time_type=arrival")
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'developer.citymapper.com', 'User-Agent' => 'HTTP Client API/1.0' })
      .to_return(status: 200, body: "{\"travel_time_minutes\":35}", headers: {})
  end

  describe '#full_data' do
    it 'returns all travel data for each London address' do
      expect(subject.full_data).to eq expected_full_data
    end
  end
end
