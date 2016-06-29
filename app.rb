require 'sinatra'
require 'httparty'
require 'json'
require 'redis'

post '/refbot' do

  redis = Redis.new

  input = params[:text].to_s.split(' ')

  case input[0].downcase
  when 'hello'
    priv_postback "Hello " + params[:user_name] + " welcome to referbot! Type /refbot help. for a list of all refbot keywords.", params[:channel_id], params[:user_name]
    break
  when 'help'
    priv_postback "This is a list off all the commands: /refbot hello, /refbot help, /refbot list, /refbot add.", params[:channel_id], params[:user_name]
    break
  when 'list'
    getlist
    break
  end

  if input[0].downcase == "new"
    redis.hmset(input[1], "name", input[2], "number", input[3], "email", input[4])
    postback redis.hmget(input[1], "name", "number", "email").to_s, params[:channel_id], params[:user_name]
    status 200
  end
end


# if input[0].downcase == "add"
#   redis.hmset("candidate", "name", "empty")
#   # postback "saved: " + redis.hmget("candidate", "name").to_s + " | database size: " + redis.dbsize.to_s, params[:channel_id], params[:user_name]
#   if redis.hmget("candidate", "name") == ["empty"]
#     postback "Enter the candidates name: ", params[:channel_id], params[:user_name]
#     input2 = params[:text].to_s.split(' ')
#     redis.hmset("candidate", "name", input2[0].to_s)
#     if redis.hmget("candidate", "name").to_s != ["empty"]
#       postback "Received name: " + redis.hmget("candidate", "name").to_s, params[:channel_id], params[:user_name]
#     end
#   end
#     status 200
#   break
# elsif input[0].downcase != "add"
#   status 200
#   break

# if input[0].downcase == "add"
#   postback "Enter the candidates name: ", params[:channel_id], params[:user_name]
#   status 200
# elsif input[0].downcase != "add"
#   savedword = redis.hmset("candidate", "name", input[0].to_s)
#   if savedword == "OK"
#     postback "saved: " + redis.hmget("candidate", "name").to_s + " | database size: " + redis.dbsize.to_s, params[:channel_id], params[:user_name]
#   end
#   status 200
# end
# end


# case input[0].downcase
#   when 'add'
#     postback "Enter the candidates name: ", params[:channel_id], params[:user_name]
#     savedword = redis.hmset("candidate", "name", input[0].to_s)
#     if add == true
#       postback "saved: " + savedword.to_s + " | database size: " + redis.dbsize.to_s, params[:channel_id], params[:user_name]
#     end
#     # break
#   status 200
# end
# end


#   case input[0].downcase
#   when 'save'
#     savedword = redis.set("savedword" + input[1], input[1])
#     if savedword == "OK"
#       postback "saved: " + input[1] + " | database size: " + redis.dbsize.to_s, params[:channel_id], params[:user_name]
#     end
#     break
#   when 'recover'
#     recoveredword = redis.get("savedword" + input[1])
#     postback "recovered: " + recoveredword + " | database size: " + redis.dbsize.to_s, params[:channel_id], params[:user_name]
#     # getlist
#     break
#   end
#   status 200
# end


def getlist
  receivelist = HTTParty.get('https://api.recruitee.com/c/levelupventures/careers/offers').to_json

  test1 = JSON.parse(receivelist, symbolize_names: true)
  contents = test1[:offers]

  contents.each do |content|
    postback content[:id] + content[:title] + content[:careers_url], params[:channel_id], params[:user_name]
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
