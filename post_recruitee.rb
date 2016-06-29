require 'json'
require 'httparty'

url = "https://api.recruitee.com/c/referbot/careers/offers/designer-voorbeeld-vacature/candidates.json"
candidate = {
  name: "Iemanjah Santos",
  email: "Jezus.s@code.co",
  phone: "551135141050"
}

HTTParty.post(url,
  body: { candidate: candidate }.to_json,
  headers: { "Content-Type" => "application/json" })
