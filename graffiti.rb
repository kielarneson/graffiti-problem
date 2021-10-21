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

  needed_alderman_data = []

  # Getting relevant alderman data
  all_alderman_data.each do |alderman|
    each_alderman = alderman["alderman"]
    split_alderman = each_alderman.split("")

    # Getting the last name
    index = 0
    last_name = []
    while index < split_alderman.length
      if split_alderman[index] == ","
        break
      else
        last_name << split_alderman[index]
      end
      index += 1
    end

    # Getting the first name
    index = split_alderman.length
    first_name = []
    while index > 0
      if split_alderman[index] == ","
        break
      else
        first_name << split_alderman[index]
      end
      index -= 1
    end

    # Putting first name and last name together to create full name
    full_name = "#{first_name.reverse.join} #{last_name.join}"

    # Passing needed alderman info into array as a hash for each Alderman
    needed_alderman_data << { :ward => alderman["ward"], :name => full_name }
  end
end

pp graffiti()
