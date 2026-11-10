require "net/http"
require "json"

class TransitApi
  BASE_URL = "https://api.winnipegtransit.com/v4".freeze

  def self.get(path, params = {})
    uri = URI("#{BASE_URL}/#{path}")
    uri.query = URI.encode_www_form(params.merge("api-key" => ENV.fetch("WINNIPEG_TRANSIT_API_KEY")))
    response = Net::HTTP.get_response(uri)
    raise "Transit API error #{response.code} for #{path}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end
end