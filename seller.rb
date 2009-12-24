require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'json'

post '/sell' do
  oneforty = RestClient::Resource.new(ENV['ONEFORTY'],
                                      :verify_ssl => OpenSSL::SSL::VERIFY_NONE)

  json = { :reference_code => params[:reference_code],
           :developer_key  => ENV['DEVELOPER_KEY'] }.to_json

  oneforty['/fulfillment/acknowledge'].post(json)

  json = { :reference_code       => params[:reference_code],
           :developer_key        => ENV['DEVELOPER_KEY'],
           :buyer_twitter_handle => params[:buyer_email] }.to_json

  oneforty['/fulfillment/complete'].post(json)

  "Sold"
end

