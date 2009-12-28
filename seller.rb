require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'json'

post '/sell' do
  oneforty = RestClient::Resource.new("https://" + ENV['ONEFORTY_ENV'],
                                      :verify_ssl => OpenSSL::SSL::VERIFY_NONE)

  json = { :reference_code => params[:reference_code],
           :developer_key  => ENV['DEVELOPER_KEY'] }

  oneforty['/fulfillment/acknowledge'].post(json)

  json = { :reference_code       => params[:reference_code],
           :developer_key        => ENV['DEVELOPER_KEY'],
           :buyer_twitter_handle => params[:buyer_email] }

  oneforty['/fulfillment/complete'].post(json)

  "Sold"
end

