require 'pp'
require 'puppet/face'
require 'net/http'
require 'uri'
require 'json'
Puppet::Type.type(:jenkins_agent).provide(:json, :parent => Puppet::Provider) do
  desc "Manage jenkins slave agents with the JSON api"

  mk_resource_methods

  def exists?
    if @property_hash[:ensure] == :present
      return true
    end
    name = @resource[:name]
    res = resource.to_hash
    server   = res[:server]
    username = res[:username]
    password = res[:password]
    api_url = "http://#{server}/computer/#{name}/api/json"
    url = URI.parse(api_url)
    request = Net::HTTP::Get.new(url.path)
    request.basic_auth(username, password) if username
    response = Net::HTTP.start(url.host, url.port) { |http| http.request(request) }
    return response.kind_of?(Net::HTTPSuccess)
  end

  def create
    puts "create called for #{@resource[:name]}"
    @property_hash = {
      :name     => @resource[:name],
      :ensure   => :present,
      :server   => @resource[:server],
      :username => @resource[:username],
      :password => @resource[:password]
    }
  end

  def destroy
    @property_hash[:ensure] = :absent
  end

  def self.instances
    Puppet.debug("Self.instances called")
    instances = []
    catalog_resources = Puppet::Face[:catalog, :current].select('*', 'jenkins_agent')

    # Get all of the unique servers.
    # Only one set of creds will be used for any given server if multiple are available
    servers = {}
    catalog_resources.each do |resource|
      res = resource.to_hash
      servers[res[:server]] = {
        :username => res[:username],
        :password => res[:password]
      }
    end

    servers.each do |server, creds|
      username = creds[:username]
      password = creds[:password]
      api_url = "http://#{server}"
      url = URI.parse(api_url)
      request = Net::HTTP::Get.new('/computer/api/json')
      request.basic_auth(username, password) if username
      response = Net::HTTP.start(url.host, url.port) { |http| http.request(request) }
      data = JSON.parse(response.body)
      data['computer'].each do |computer|
        next if computer["displayName"] == "master"

        properties = {
          :name     => computer["displayName"],
          :ensure   => :present,
          :server   => server,
          :username => username,
          :password => password,
          :provider => :json
        }
        instances << new(properties)
      end
    end
    return instances
  end

  def flush
    server   = @property_hash[:server]
    username = @property_hash[:username]
    password = @property_hash[:password]
    host     = @property_hash[:name]

    if @property_hash[:ensure] == :present
      api_json = JSON.generate({
        "launcher" => {
          "stapler-class" => "hudson.plugins.sshslaves.SSHLauncher",
          "host" => host
        },
        "numExecutors" => 2,
        "nodeProperties" => {
          "stapler-class-bag" => "true"
        },
        "name" => host,
        "retentionStrategy" => {
          "stapler-class" => "hudson.slaves.RetentionStrategy$Always"
        },
        "remoteFS" => "/home/jenkins",
        "type" => "hudson.slaves.DumbSlave$DescriptorImpl",
        "nodeDescription" => host,
        "labelString" => host,
        "mode" => "NORMAL"
      })

      api_url = "http://#{server}/computer/doCreateItem?json=#{api_json}&type=hudson.slaves.DumbSlave$DescriptorImpl&name=#{name}"
      url = URI.parse(URI.escape(api_url))
      request = Net::HTTP::Get.new("#{url.path}?#{url.query}")
      request.basic_auth(username, password) if username
      response = Net::HTTP.start(url.host, url.port) { |http| http.request(request) }
      puts response.body
    else
      api_url = "http://#{server}/computer/#{name}/doDelete"
      url = URI.parse(api_url)
      request = Net::HTTP::Get.new(url.path)
      request.basic_auth(username, password) if username
      response = Net::HTTP.start(url.host, url.port) { |http| http.request(request) }
    end
  end
end
