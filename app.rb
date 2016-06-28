require 'sinatra'
require 'httparty'
require 'json'

# post '/refbot' do
#   postback params[:text], params[:channel_id], params[:user_name]
#   status 200
# end

post '/refbot' do
  input = params[:text].to_s.split(' ')
  case input[0].downcase
  when 'hello'
    postback params[:text], params[:channel_id], params[:user_name]
    break
  when 'list'
    getlist
  status 200
  end
end

def getlist
  gettest = HTTParty.get('https://api.recruitee.com/c/levelupventures/careers/offers').to_json

  test = JSON.parse(gettest, symbolize_names: true)
  contents = test[:offers]

  contents.each do |content|
    # p content[:title]
    # puts
    # p content[:careers_url]
    # puts

    postback content[:title], params[:channel_id], params[:user_name]

    # slack_webhook = ENV['SLACK_WEBHOOK_URL']
    # HTTParty.post slack_webhook, body: {"text" => content[:title], "username" => "refbot", "channel" => params[:channel_id]}.to_json, headers: {'content-type' => 'application/json'}
  end
end


def postback message, channel, user
    slack_webhook = ENV['SLACK_WEBHOOK_URL']
    HTTParty.post slack_webhook, body: {"text" => message, "username" => "refbot", "channel" => params[:channel_id]}.to_json, headers: {'content-type' => 'application/json'}
end

# get '/refbot' do
#   jsoncontent = {"text" => "refbot response", "username" => "refbot", "channel" => params[:channel_id]}
#   newjson = JSON.pretty_generate(jsoncontent)
#   File.open("userdata.json","w") do |f|
#     f.write(newjson)
#   end
#   newjson
# end
