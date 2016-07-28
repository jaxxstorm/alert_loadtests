require 'net/https'
require 'uri'
require 'json'
require 'trollop'
require 'pp'


opts = Trollop::options do
	opt :customer_key, "opsgenie customer key", :type => :string
  opt :number, "Number of alerts to generate", :default => 1000
end

Trollop::die :customer_key, "Must supply customer key" if opts[:customer_key].nil?




def post_to_opsgenie(action = :create, params = {})

  uripath = (action == :create) ? '' : 'close'
  uri = URI.parse("https://api.opsgenie.com/v1/json/alert/#{uripath}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
  request.body = params.to_json
  response = http.request(request)
  result = JSON.parse(response.body)

  if result['status'] == "successful"
    if result['code'] == 200
      print  "Created alert #{result['alertId'].chomp}\n"
    else
      print "Updated alert #{result['alertId'].chomp}\n"
    end
  end


end

opts[:number].to_i.times do |i|
  post_to_opsgenie(:create, alias: "test_alert_#{i}", message: "Load test generation alert: Number #{i}", description: 'Please ignore, load test generation alert', entity: 'load_test_script', customerKey: opts[:customer_key])
end

