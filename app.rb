require 'sinatra'
require 'httparty'
require 'json'
require 'sinatra'


post '/refbot' do
  input = params[:text].to_s.split(' ')
  case input[0].downcase
  when 'hello'
    priv_postback "Hello " + params[:user_name], params[:channel_id], params[:user_name]
    break
  when 'list'
    getlist
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
