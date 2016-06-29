require "sinatra"
require "httparty"
require 'json'

class Partay
  include HTTParty
  base_uri 'http://localhost:3000'
end

options = {

}


Partay.post('https://api.recruitee.com/c/referbot/careers/offers/designer-voorbeeld-vacature/candidates', body: {
  "candidate": {
    "name": "Tony", 
    "email": "blabla@blabla.nl",
    "phone": "0692349851",
    "remote_cv_url": "https://site.example.com/resumes/myresume.pdf"
  }
},
headers: { 'Content-Type' => 'application/json'})
