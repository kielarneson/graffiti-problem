require "http"

def graffiti
  # Graffiti web request
  response = HTTP.get("https://data.cityofchicago.org/resource/hec5-y4x5.json")
  all_graffiti_data = JSON.parse(response.body)
end

pp graffiti()
