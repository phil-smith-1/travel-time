require 'pry'

class Result
  def initialize(params)
    @params = params
    @start_date_time = Time.parse(@params['start_date_time'])
    add_first_address
  end

  def full_data
    @full_data = []
    @params['postcodes'].each_with_index do |postcode, index|
      @full_data << { postcode: postcode, appointment_duration: @params['appointment_durations'][index].to_i }
    end

    add_coords
    add_travel_details

    @full_data
  end

  private

  def add_first_address
    @params['postcodes'].unshift('EC1A 9HF')
    @params['appointment_durations'].unshift(0)
  end

  def add_coords
    @full_data.each do |data|
      postcode_data = PostcodeLookup.new(data[:postcode]).lookup

      if postcode_data.count < 1 || postcode_data.fetch('region') != 'London'
        data[:skip] = true
        next
      end

      data.merge!(
        latitude: postcode_data['latitude'],
        longitude: postcode_data['longitude'],
        skip: false
      )
    end
    @full_data.reject! { |data| data[:skip] }
  end

  def add_travel_details
    time_to_use = @start_date_time
    @full_data.each_cons(2) do |start_loc, end_loc|
      start_loc[:departure_date_time] = time_to_use

      travel_time_minutes = TravelTime.new(
        start_coords: "#{start_loc[:latitude]},#{start_loc[:longitude]}",
        end_coords: "#{end_loc[:latitude]},#{end_loc[:longitude]}",
        start_date_time: time_to_use.iso8601
      ).get_travel_time[:time]

      end_loc.merge!(arrival_date_time: time_to_use + travel_time_minutes * 60, travel_time_minutes: travel_time_minutes)

      time_to_use += (travel_time_minutes + end_loc[:appointment_duration]) * 60
    end
    @full_data.last[:departure_date_time] = time_to_use
  end
end
