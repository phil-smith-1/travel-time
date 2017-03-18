require 'sinatra'

get '/' do
  erb :form
end

post 'results' do
  @result = Result.new(params)
  erb :results
end

require_relative 'models/result'
