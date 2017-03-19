require 'spec_helper'
require_relative '../models/postcode_lookup'

RSpec.describe PostcodeLookup, type: :model do
  let(:valid_postcode) { 'E1 6LA' }
  let(:invalid_postcode) { '12345' }

  let(:expected_valid_postcode_data) do
    {
      'latitude' => 51.5199746402298,
      'longitude' => -0.0984090718153747,
      'region' => 'London'
    }
  end
  let(:expected_invalid_postcode_data) { {} }

  subject { PostcodeLookup }

  before do
    stub_request(:get, 'http://api.postcodes.io/postcodes/E1%206LA')
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'api.postcodes.io', 'User-Agent' => 'HTTP Client API/1.0' })
      .to_return(status: 200, body: "{\"result\":{\"longitude\":-0.0984090718153747,\"latitude\":51.5199746402298,\"region\":\"London\"}}", headers: {})
    stub_request(:get, 'http://api.postcodes.io/postcodes/12345')
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'api.postcodes.io', 'User-Agent' => 'HTTP Client API/1.0' })
      .to_return(status: 404, body: "{}", headers: {})
  end

  describe '#lookup' do
    it 'returns valid postcode data' do
      expect(subject.new(valid_postcode).lookup).to eq expected_valid_postcode_data
    end

    it 'returns invalid postcode data' do
        expect(subject.new(invalid_postcode).lookup).to eq expected_invalid_postcode_data
    end
  end
end
