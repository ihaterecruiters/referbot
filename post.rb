# dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
# require File.join(dir, 'httparty')

# require 'sinatra'
require 'httparty'
require 'json'


# class Partay
#   include HTTParty
#   base_uri 'http://localhost:3000'
# end


url = "https://api.recruitee.com/c/referbot/careers/offers/designer-voorbeeld-vacature/candidates.json"
candidate = {
  name: "Jezus Smith",
  email: "Jezus.s@code.co",
  phone: "3984093808098",
  remote_cv_url: "http://cd.sseu.re/welcome-pdf.pdf"
}

HTTParty.post(url,
  body: { candidate: candidate }.to_json,
  headers: { "Content-Type" => "application/json" })

  
# HTTParty.post("https://api.recruitee.com/c/referbot/careers/offers/designer-voorbeeld-vacature/candidates.json",
#    {
#      :body => [ :candidate => {:name => "Fabiano", :email => "blabla@blabla.nl", :phone => "0692349851", :remote_cv_url => "https://site.example.com/resumes/myresume.pdf"}, ].to_json,
#      :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
#    })
   #
   #
  #  response = HTTParty.post('https://api.recruitee.com/c/referbot/careers/offers/designer-voorbeeld-vacature/candidates.json')
  #  puts response.body, response.headers.inspect
