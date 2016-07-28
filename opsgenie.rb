require 'net/https'
require 'uri'
require 'json'
require 'trollop'
require 'pp'
require 'typhoeus'


opts = Trollop::options do
	opt :customer_key, "opsgenie customer key", :type => :string
  opt :number, "Number of alerts to generate", :default => 1000
end

Trollop::die :customer_key, "Must supply customer key" if opts[:customer_key].nil?




def post_to_opsgenie(action = :create, number = opts[:number], params = {})


  uripath = (action == :create) ? '' : 'close'
  url = "https://api.opsgenie.com/v1/json/alert/#{uripath}"


  hydra = Typhoeus::Hydra.hydra
  requests = number.times.map {
    request = Typhoeus::Request.new("#{url}", :method => :post, :timeout => 30000, :header   => {:Accept => "application/json", 'Content-Type' => "application/json"}, :body => params.to_json)
    hydra.queue(request)
    request
  }
  hydra.run  # exception thrown on this line

  responses = requests.map { |request|
    pp request.response.body
  }


  #if result['status'] == "successful"
  #  if result['code'] == 200
  #    print  "Created alert #{result['alertId'].chomp}\n"
  #  else
  #    print "Updated alert #{result['alertId'].chomp}\n"
  #  end
  #end


end

post_to_opsgenie(:create, opts[:number],  alias: "test_alert", message: "Load test generation alert", description: 'Please ignore, load test generation alert', entity: 'load_test_script', customerKey: opts[:customer_key])

