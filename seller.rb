require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'json'

post '/sell' do
  post_data = JSON.load(request.body.read.to_s)
  oneforty = RestClient::Resource.new("https://" + ENV['ONEFORTY_ENV'],
                                      :verify_ssl => OpenSSL::SSL::VERIFY_NONE)

  json = { :reference_code => post_data["reference_code"],
           :developer_key  => ENV['DEVELOPER_KEY'] }.to_json

  ack_response = JSON.parse(oneforty['/fulfillment/acknowledge'].post(json))

  json = { :reference_code       => post_data["reference_code"],
           :developer_key        => ENV['DEVELOPER_KEY'],
           :buyer_twitter_handle => ack_response['buyer_twitter_handle'] }.to_json

  complete_response = oneforty['/fulfillment/complete'].post(json)
  
  status complete_response.code == 200 ? 200 : 500 # 200 from oneforty means we are all done!

  "Sold"
end

