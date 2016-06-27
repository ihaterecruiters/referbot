require 'sinatra'
require 'httparty'
require 'json'

get '/refbot' do
  postback params[:text], params[:channel_id], params[:user_name]
  status 200
end

def postback message, channel
    slack_webhook = ENV['SLACK_WEBHOOK_URL']
    HTTParty.post slack_webhook, body: {"text" => "Hi, " + params[:user_name], "username" => "refbot", "channel" => params[:channel_id]}.to_json, headers: {'content-type' => 'application/json'}
end
