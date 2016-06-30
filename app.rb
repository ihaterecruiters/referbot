require 'sinatra'
require 'httparty'
require 'json'
require 'redis'

post '/refbot' do

  redis = Redis.new

  input = params[:text].to_s.split(' ')

  case input[0].downcase
  when 'hello'
    postback "Hello " + params[:user_name] + " welcome to referbot! Type /refbot help. for a list of all refbot keywords.", params[:channel_id], params[:user_name]
    break
  when 'help'
    postback "This is a list off all the commands: /refbot hello, /refbot help, /refbot list, /refbot new, /refbot new name email phone", params[:channel_id], params[:user_name]
    break
  when 'list'
    getlist
    break
  end

  if input[0].downcase == "new"
    redis.hmset(input[1], "name", input[2], "email", input[3], "phone", input[4])
    postback redis.hmget(input[1], "name", "email", "phone").to_s, params[:channel_id], params[:user_name]

    url = "https://api.recruitee.com/c/referbot/careers/offers/designer-voorbeeld-vacature/candidates.json"
    candidate = {
      name: redis.hmget(input[1], "name")[0].to_s,
      email: redis.hmget(input[1], "email")[0].to_s,
      phone: redis.hmget(input[1], "phone")[0].to_s,
      remote_cv_url: "http://cd.sseu.re/welcome-pdf.pdf"
    }

    HTTParty.post(url,
      body: { candidate: candidate }.to_json,
      headers: { "content-type" => "application/json" })

    status 200
  end
end

# def post_candidate
#   url = "https://api.recruitee.com/c/referbot/careers/offers/designer-voorbeeld-vacature/candidates.json"
#   candidate = {
#     name: redis.hmget(input[1], "name")[0].to_s,
#     email: redis.hmget(input[1], "email")[0].to_s,
#     phone: redis.hmget(input[1], "phone")[0].to_s,
#     remote_cv_url: "http://cd.sseu.re/welcome-pdf.pdf"
#   }
#
#   HTTParty.post(url,
#     body: { candidate: candidate }.to_json,
#     headers: { "content-type" => "application/json" })
# end


# def post_candidate
#   url = "https://api.recruitee.com/c/referbot/careers/offers/designer-voorbeeld-vacature/candidates.json"
#   candidate = {
#     name: "Jezus Smith",
#     email: "Jezus.s@code.co",
#     phone: "3984093808098",
#     remote_cv_url: "http://cd.sseu.re/welcome-pdf.pdf"
#   }
#
#   HTTParty.post(url,
#     body: { candidate: candidate }.to_json,
#     headers: { "Content-Type" => "application/json" })
# end

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
    message = "#{content[:id]}, #{content[:title]}  \n   visit it at: #{content[:careers_url]}"
   postback message, params[:channel_id], params[:user_name]
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

# def priv_postback message, channel, user
#     slack_webhook = ENV['SLACK_WEBHOOK_URL']
#     HTTParty.post slack_webhook, body: {"text" => message, "username" => "refbot", "channel" => params[:channel_id] }.to_json, headers: {'content-type' => 'application/json'}
# end
