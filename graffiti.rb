require "http"

def graffiti(alderman)
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

  # pp all_alderman_data

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
    index = split_alderman.length - 1
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
    full_name = "#{first_name.slice(0..-2).reverse.join} #{last_name.join}"

    # Passing needed alderman info into array as a hash for each Alderman
    needed_alderman_data << { :ward => alderman["ward"], :name => full_name }
  end

  # Adding Graffiti data and Alderman data together if they have the same ward
  all_data = []
  index1 = 0
  index2 = 0
  while index1 < needed_graffiti_data.length
    while index2 < needed_alderman_data.length
      if needed_graffiti_data[index1][:ward] == needed_alderman_data[index2][:ward]
        all_data << {
          :ward => needed_alderman_data[index2][:ward],
          :alderman => needed_alderman_data[index2][:name],
          :month => needed_graffiti_data[index1][:month],
          :year => needed_graffiti_data[index1][:year],
        }
      end
      index2 += 1
    end
    index1 += 1
    index2 = 0
  end

  # Displaying final data for specific alderman
  specific_data = all_data.select { |specific_alderman| specific_alderman[:alderman] == alderman }
  specific_data[0][:removal_requests] = specific_data.length

  p specific_data[0]
end

graffiti("Patrick D. Thompson")
