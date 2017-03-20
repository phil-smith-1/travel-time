require 'dotenv/load'
require 'sinatra'

class WebApp < Sinatra::Base
  get '/' do
    @date_time_now = Time.now.strftime('%Y-%m-%dT%H:%M')
    erb :form
  end

  get '/postcode-form' do
    erb :postcode_form_group, layout: false
  end

  post '/results' do
    @results = Result.new(params).full_data
    erb :results
  end

  require_relative 'models/init'
end
