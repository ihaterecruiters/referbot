class Partay
  include HTTParty
  base_uri 'http://localhost:3000'
end

options = {
  body: {
    candidate: { # your resource
      name: 'Tony', # your columns/data
      email: 'blabla@blabla.nl',
      phone: '0692349851',
      remote_cv_url: 'https://site.example.com/resumes/myresume.pdf'
    }
  },
  headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
}

options.to_json

Partay.post('https://api.recruitee.com/c/referbot/careers/offers/designer-voorbeeld-vacature/candidates.json', options)
