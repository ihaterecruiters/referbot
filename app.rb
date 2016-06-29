require 'sinatra'
require 'httparty'
require 'json'

get '/refbot' do
  postback params[:text], params[:channel_id]
  status 200
end
#
# def postback message, channel
#     slack_webhook = ENV['SLACK_WEBHOOK_URL']
#     HTTParty.post slack_webhook, body: {"text" => "testing", "username" => "refbot", "channel" => params[:channel_id]}.to_json, headers: {'content-type' => 'application/json'}
# end


# def getvacancies message, channel
#     slack_webhook = ENV['SLACK_WEBHOOK_URL']
#     HTTParty.get(https://api.recruitee.com/c/levelupventures/careers/offers.json).parsed_response slack_webhook, body: {"text" => "testing", "username" => "refbot", "channel" => params[:channel_id]}.to_json, headers: {'content-type' => 'application/json'}
# end


# 
#  HTTParty.post("https://api.recruitee.com/c/referbot/careers/offers/designer-voorbeeld-vacature/candidates", :candidate => {:name => "Fabiano", :email => "blabla@blabla.nl", :phone => "0692349851", :remote_cv_url => "https://site.example.com/resumes/myresume.pdf"}, :headers => {Content-Type: => "application/json
# "})
#
#
#  https://referbot.recruitee.com/o/designer-voorbeeld-vacature


 HTTParty.post("https://api.recruitee.com/c/referbot/careers/offers/designer-voorbeeld-vacature/candidates",
   {
     :body => [ :candidate => {:name => "Fabiano", :email => "blabla@blabla.nl", :phone => "0692349851", :remote_cv_url => "https://site.example.com/resumes/myresume.pdf"}, ].to_json,
     :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
   })
