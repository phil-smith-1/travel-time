require 'http-client'
require 'json'

class PostcodeLookup
  def initialize(postcode)
    @postcode = postcode
  end

  def lookup
    uri = URI.encode("http://api.postcodes.io/postcodes/#{@postcode}")
    response = HTTP::Client.get(uri)
    json_response = JSON.parse(response.body)

    return {} unless response.code == 200

    json_response['result']
  end
end
