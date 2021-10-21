require "http"

def graffiti
  # Graffiti web request
  response = HTTP.get("https://data.cityofchicago.org/resource/hec5-y4x5.json")
  all_graffiti_data = JSON.parse(response.body)

  index = 0
  needed_graffiti_data = []

  # Getting relevant graffiti data
  all_graffiti_data.each do |graffiti|
    year = graffiti["creation_date"].slice(0..3)
    month = graffiti["creation_date"].slice(5..6)
    ward = graffiti["ward"]
    needed_graffiti_data << { :year => year, :month => month, :ward => ward }
  end

  # Alderman web request
  response = HTTP.get("https://data.cityofchicago.org/resource/htai-wnw4.json")
  all_alderman_data = JSON.parse(response.body)
end

pp graffiti()
