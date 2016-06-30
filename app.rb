require 'sinatra'
require 'httparty'
require 'json'
require 'redis'

post '/refbot' do

  redis = Redis.new

  input = params[:text].to_s.split(' ')
  message = ""
  case input[0].downcase
  when 'hello'
    message = "Hello " + params[:user_name] + " welcome to referbot! Type /refbot help. for a list of all refbot keywords."
    message = checklist
  when 'help'
    message = "This is a list off all the commands: /refbot hello, /refbot help, /refbot list, /refbot new, /refbot new candidate first-name last-name email phone vacancy"
  when 'list'
    message = getlist
  # when 'new'
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

  json_message = {"text" => message, params[:user_name] => "refbot", "channel" => params[:channel_id]}
  if ENV['DEV_ENV'] == 'test'
    content_type :json
   json_message.to_json
  else
    slack_webhook = ENV['SLACK_WEBHOOK_URL']
    HTTParty.post slack_webhook, body: json_message.to_json, headers: {'content-type' => 'application/json'}
  end
end


def getlist
  receivelist = HTTParty.get('https://api.recruitee.com/c/referbot/careers/offers').to_json
  # receivelist = HTTParty.get('https://api.recruitee.com/c/levelupventures/careers/offers').to_json

  test1 = JSON.parse(receivelist, symbolize_names: true)
  contents = test1[:offers]
  message = ""
  contents.each do |content|
    message = message + "#{content[:id]}, #{content[:title]} \n #{content[:careers_url]} \n"
  end
  return message;
end

def checklist
  check_list = HTTParty.get('https://api.recruitee.com/c/referbot/careers/offers').to_json

  test1 = JSON.parse(check_list, symbolize_names: true)
  contents = test1[:offers]
  message = contents.size.to_s
  contents.size
  return message
end
