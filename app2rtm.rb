require 'http'
require 'json'
require 'sinatra'

rc = JSON.parse HTTP.post("https://slack.com/api/rtm.start", params: {
  token: ENV['SLACK_API_TOKEN'],
})

url = rc['url']
puts url

require 'faye/websocket'
require 'eventmachine'

EM.run {
  ws = Faye::WebSocket::Client.new(url)

  require 'httparty'
  def getlist
    receivelist = HTTParty.get('https://api.recruitee.com/c/levelupventures/careers/offers').to_json

    test1 = JSON.parse(receivelist, symbolize_names: true)
    contents = test1[:offers]

    contents.each do |content|
      postback content[:title], "yellos", 'user'
    end
  end

  def postback message, channel, user
    slack_webhook = ENV['SLACK_WEBHOOK_URL']
    HTTParty.post slack_webhook, body: {"text" => message, "username" => "refbot", "channel" => params[:channel_id]}.to_json, headers: {'content-type' => 'application/json'}
  end

  def priv_postback message, channel, user
    slack_webhook = ENV['SLACK_WEBHOOK_URL']
    HTTParty.post slack_webhook, body: {"text" => message, "username" => "refbot", "channel" => params[:channel_id] }.to_json, headers: {'content-type' => 'application/json'}
  end

  ws.on :open do |event|
    p [:open]
  end

  ws.on :message do |event|
    data = JSON.parse(event.data) if event && event.data
    p [:message, data]
  case
  when data && data['type'] == 'message' && data['text'] == 'refbot'
    ws.send({ type: 'message', text: "hi <@#{data['user']}> welcome to referbot. Type help for a list of all refbot keywords", channel: data['channel'] }.to_json)

  when data && data['type'] == 'message' && data['text'] == 'help'
    ws.send({ type: 'message', text: "<@#{data['user']}> -refbothelp -refbotadd -refbotlol", channel: data['channel'] }.to_json)

  when data && data['type'] == 'message' && data['text'] == 'list'
    ws.send(getlist)

  end
end


 ws.on :close do |event|
   p [:close, event.code, event.reason]
   ws = nil
 end
}
