require 'sinatra'
require 'httparty'
require 'json'

class Recruitee
  include HTTParty
  format :json
end

gettest = Recruitee.get('https://api.recruitee.com/c/levelupventures/careers/offers').to_json

test = JSON.parse(gettest, symbolize_names: true)
contents = test[:offers]

contents.each do |content|
  p content [:id]
  p content[:title]
  p content[:careers_url]
  #print "Offer ID: " content [:id] \n "Title: " "*"content[:title]"*"\n "URL: "[:careers_url]
end
