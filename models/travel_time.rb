require 'http-client'
require 'json'

class TravelTime
  CITY_MAPPER_KEY = ENV['CITY_MAPPER_KEY'].freeze
  CITY_MAPPER_BASE_URL = 'https://developer.citymapper.com/api/1'.freeze

  def initialize(args)
    @args = args
  end

  def get_travel_time
    start_coords = @args[:start_coords]
    end_coords = @args[:end_coords]
    start_date_time = @args[:start_date_time]

    uri = URI.encode(
      "#{CITY_MAPPER_BASE_URL}/traveltime/?startcoord=#{start_coords}&endcoord=#{end_coords}&time=#{start_date_time}&time_type=arrival&key=#{CITY_MAPPER_KEY}"
    )
    response = HTTP::Client.get(uri)

    return { error: true, time: 0 } unless response.code == 200

    json_response = JSON.parse(response.body)

    { error: false, time: json_response['travel_time_minutes'] }
  end
end
