require 'net/http'

module Puppet::Parser::Functions
  newfunction(:fetch_agent_token, :type => :rvalue) do |args|
    url = args[0]
    username = nil
    password = nil

    if args.length > 1
    	username = args[1]
    	password = args[2]
    end

    uri = URI(url)
    jnlp = ''
    resp = nil
    secret = ''

	  Net::HTTP.start(uri.hostname, uri.port) do |http|
	    req = Net::HTTP::Get.new(uri.path)
	    
	    if username != nil and password != nil
	      req.basic_auth(username, password)
	    end
	    
	    resp = http.request(req)
	  end

	  if resp.code == '200'
	  	secret = /<argument>(.{64})<\/argument>/.match(resp.body)[1]
	  end

	  secret
  end
end