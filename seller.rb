require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'json'

post '/sale_notification' do
  one_forty = RestClient::Resource.new("sandbox.oneforty.com", :verify_ssl =>  OpenSSL::SSL::VERIFY_NONE)

  one_forty['/fulfillment/acknowledge'].post :reference_code => params[:reference_code],
                                             :developer_key => ENV['DEVELOPER_KEY']

  one_forty['/fulfillment/complete'].post { :reference_code       => params[:reference_code],
                                            :developer_key        => ['DEVELOPER_KEY'],
                                            :buyer_twitter_handle => params[:buyer_email] }.to_json

  "Sold"
end

