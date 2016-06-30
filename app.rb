require 'sinatra'
require 'httparty'
require 'json'
require 'redis'

post '/refbot' do

  redis = Redis.new

  input = params[:text].to_s.split(' ')

  case input[0].downcase
  when 'hello'
    # currentpost
    postback "Hello " + params[:user_name] + " welcome to referbot! Type /refbot help. for a list of all refbot keywords.", params[:channel_id], params[:user_name]
    break
  when 'help'
    postback "This is a list off all the commands: /refbot hello, /refbot help, /refbot list, /refbot new, /refbot new candidate first-name last-name email phone vacancy", params[:channel_id], params[:user_name]
    break
  when 'list'
    getlist
    break
  end

  if input[0].downcase == "new"
    if !redis.exists(params[:user_id])
      redis.mapped_hmset(params[:user_id], {"candidate_0": {firstname: "", lastname: "", email: "", phone: "", vacancy: ""}, "step": "1"})
      postback params[:user_id] + " does not exist in the database. Created. Type '/refbot name: <candidate name>' to start adding a new candidate.", params[:channel_id], params[:user_name]
    elsif redis.exists(params[:user_id])
      postback params[:user_id] + " exists in the database. Type '/refbot name: <candidate name>' to start adding a new candidate.", params[:channel_id], params[:user_name]
    # elsif redis.hmget(params[:user_id], "step")[0].to_s == "1"
    #   redis.hmset(params[:user_id], "step", "2")
    #   postback params[:user_id] + " exists in the database. Adding candidate (step 1/6). Name: ", params[:channel_id], params[:user_name]
    # elsif redis.hmget(params[:user_id], "step")[0].to_s == "2"
    #   redis.hmset(params[:user_id], "step", "3")
    #   postback params[:user_id] + " Added name. Adding candidate (step 2/6). Email: ", params[:channel_id], params[:user_name]
    end
  end

  if input[0].downcase == "name" and redis.hmget(params[:user_id], "step")[0].to_s == "1"
    redis.hmset(params[:user_id], "candidate_0"["firstname"], input[1])
    # redis.mapped_hmset(params[:user_id], "candidate_0"["lastname"] = input[2])
    # redis.mapped_hmset(params[:user_id], "step", "2")
    # firstname = redis.hmget(params[:user_id], "candidate_0"["firstname"])
    firstnamedb = redis.hmget(params[:user_id], "candidate_0")

    postback "Name: " + firstnamedb.to_s, params[:channel_id], params[:user_name]
  end

  # if input[0].downcase == "new"
  #   redis.hmset(input[1], "firstname", input[2], "lastname", input[3], "email", input[4], "phone", input[5], "vacancy", input[6])
  #   # postback redis.hmget(input[1], "firstname", "lastname", "email", "phone", "vacancy").to_s, params[:channel_id], params[:user_name]
  #
  #   url = "https://api.recruitee.com/c/referbot/careers/offers/#{redis.hmget(input[1], "vacancy")[0].to_s}/candidates.json"
  #   candidate = {
  #     name: redis.hmget(input[1], "firstname")[0].to_s + " " + redis.hmget(input[1], "lastname")[0].to_s,
  #     email: redis.hmget(input[1], "email")[0].to_s,
  #     phone: redis.hmget(input[1], "phone")[0].to_s,
  #     remote_cv_url: "http://cd.sseu.re/welcome-pdf.pdf"
  #   }
  #
  #   HTTParty.post(url,
  #     body: { candidate: candidate }.to_json,
  #     headers: { "content-type" => "application/json" })
  #
  #     postback params[:user_name].to_s + " has just refered a new candidate for the following vacancy: https://referbot.recruitee.com/o/#{redis.hmget(input[1], "vacancy")[0].to_s}", params[:channel_id], params[:user_name]
  #
  #   status 200
  # end
end


def getlist
  receivelist = HTTParty.get('https://api.recruitee.com/c/referbot/careers/offers').to_json
  # receivelist = HTTParty.get('https://api.recruitee.com/c/levelupventures/careers/offers').to_json

  test1 = JSON.parse(receivelist, symbolize_names: true)
  contents = test1[:offers]

  contents.each do |content|
    message = "#{content[:id]}, #{content[:title]} \n #{content[:careers_url]}"
    postback message, params[:channel_id], params[:user_name]
  end
end

def currentpost
  test1 = JSON.parse(receivelist, symbolize_names: true)
  contents = test1[:offers]

  current_post = []

  contents.each do |content|
    current_post << content[:id]

  end
  postback current_post.to_s, params[:channel_id], params[:user_name]
  redis.set post current_post.count
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
