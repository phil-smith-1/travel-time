require 'spec_helper'
require_relative '../models/travel_time'

RSpec.describe TravelTime, type: :model do
  let(:valid_args) do
    {
      start_coords: '51.5199746402298,-0.0984090718153747',
      end_coords: '51.5242316254431,-0.0738260998538828',
      start_date_time: Time.parse('2017-03-19T20:00').iso8601
    }
  end

  let(:invalid_args) do
    {
      start_coords: '0,0',
      end_coords: '1,1',
      start_date_time: Time.parse('2017-03-19T20:00').iso8601
    }
  end

  let(:expected_valid_response) do
    {
      error: false,
      time: 15
    }
  end

  let(:expected_invalid_response) do
    {
      error: true,
      time: 0
    }
  end

  subject { TravelTime }

  before do
    stub_request(:get, "https://developer.citymapper.com/api/1/traveltime/?endcoord=51.5242316254431,-0.0738260998538828&key=&startcoord=51.5199746402298,-0.0984090718153747&time=2017-03-19T20:00:00%2000:00&time_type=arrival")
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'developer.citymapper.com', 'User-Agent' => 'HTTP Client API/1.0' })
      .to_return(status: 200, body: "{\"travel_time_minutes\":15}", headers: {})
    stub_request(:get, "https://developer.citymapper.com/api/1/traveltime/?endcoord=1,1&key=&startcoord=0,0&time=2017-03-19T20:00:00%2000:00&time_type=arrival")
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'developer.citymapper.com', 'User-Agent' => 'HTTP Client API/1.0' })
      .to_return(status: 403, body: "", headers: {})
  end

  describe '#get_travel_time' do
    it 'returns travel time with valid data' do
      expect(subject.new(valid_args).get_travel_time).to eq expected_valid_response
    end

    it 'returns zero response with invalid data' do
      expect(subject.new(invalid_args).get_travel_time).to eq expected_invalid_response
    end
  end
end
