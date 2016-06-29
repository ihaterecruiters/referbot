require 'sinatra'
require 'httparty'
require 'json'
require 'redis'

post '/refbot' do

  redis = Redis.new
  redis.flushdb
  # redis.set "foo", [1, 2, 3].to_json
  # redis.set("mykey", params[:text])
  # sentence = redis.get("mykey")
  # redis_output = JSON.parse(redis.get("foo"))

  input = params[:text].to_s.split(' ')
  case input[0].downcase
  when 'save'
    savedword = redis.set("savedword" + input[1], input[1])
    if savedword == "OK"
      postback "Saved: " + input[1], params[:channel_id], params[:user_name]
    end
    break
  when 'recover'
    recoveredword = redis.get("savedword")
    postback "Recovered: " + recoveredword + " database size: " + redis.dbsize.to_s, params[:channel_id], params[:user_name]
    # getlist
    break
  end
  status 200
end

def getlist
  receivelist = HTTParty.get('https://api.recruitee.com/c/levelupventures/careers/offers').to_json

  test1 = JSON.parse(receivelist, symbolize_names: true)
  contents = test1[:offers]

  contents.each do |content|
    postback content[:title], params[:channel_id], params[:user_name]
  end
end


# def write_json
#   jsoncontent = {"text" => "refbot response", "username" => "refbot", "channel" => params[:channel_id]}
#   newjson = JSON.pretty_generate(jsoncontent)
#   File.open("userdata.json","w") do |f|
#     f.write(newjson)
#   end
#   newjson
# end


def postback message, channel, user
    slack_webhook = ENV['SLACK_WEBHOOK_URL']
    HTTParty.post slack_webhook, body: {"text" => message, "username" => "refbot", "channel" => params[:channel_id]}.to_json, headers: {'content-type' => 'application/json'}
end

def priv_postback message, channel, user
    slack_webhook = ENV['SLACK_WEBHOOK_URL']
    HTTParty.post slack_webhook, body: {"text" => message, "username" => "refbot", "channel" => params[:channel_id] }.to_json, headers: {'content-type' => 'application/json'}
end
