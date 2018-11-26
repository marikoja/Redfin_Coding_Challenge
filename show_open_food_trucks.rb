require 'net/http'
require 'json'

class ShowOpenFoodTrucks

  def initialize
    # Set day and time of search
    day = Time.now.strftime("%A")
    hour = Time.now.strftime("%H:%M")

    # Set API endpoint and define search params
    uri = URI.parse('http://data.sfgov.org/resource/bbb8-hzi6.json')
    params = { :dayofweekstr => day }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    @food_truck_list = []
    if res.is_a?(Net::HTTPSuccess)
      JSON.parse(res.body).each do |truck|
        if truck["end24"] >= hour
          @food_truck_list << truck
        end
      end
    else
      raise "HTTP request failed"
    end

    alpha_sort("applicant")
  end

  # Sort responses alphabetically
  def alpha_sort(sort_field)
    @food_truck_list.sort_by! { |truck| truck[sort_field]}
  end

  def print_trucks

    if (@food_truck_list.length == 0)
      puts "No food trucks found."
    else
      total_count = 0
      display_count = 0
      display_more = true

      # loop while there are still more food trucks to display and
      # we've displayed less than 10 for this current run and the
      # user still wants to see more food truck results
      while (total_count < @food_truck_list.length && display_count < 10 && display_more == true)
        self.search_output(total_count)
        total_count += 1
        display_count += 1

        # if there are still more food trucks to display and we've just displayed a set of 10,
        # then prompt the user if they want to see more food truck results
        if (total_count < @food_truck_list.length && display_count == 10)
          display_count = 0
          display_more = self.ask_display_more
        end
      end
    end
  end

  # Print out responses
  def search_output(index)
    if @food_truck_list[index]["applicant"] && @food_truck_list[index]["location"]
      puts "NAME: " + @food_truck_list[index]["applicant"] + "\n\tADDRESS: " + @food_truck_list[index]["location"]
    elsif @food_truck_list[index]["applicant"] && !@food_truck_list[index]["location"]
      puts "NAME: " + @food_truck_list[index]["applicant"] + "\n\tADDRESS: "+ "location unknown"
    elsif !@food_truck_list[index]["applicant"] && @food_truck_list[index]["location"]
      puts (index + 1).to_s + ") " + @food_truck_list[index]["optionaltext"] + "\n\tADDRESS: "+ @food_truck_list[index]["location"]
    else
      raise "Data error"
    end
  end

  def ask_display_more
    puts "Would you like to see more results (Yes/No)?"
    continue = gets.chomp.upcase
    if (continue != "Y" && continue != "N" && continue != "YES" && continue != "NO")
        puts "Please give YES or NO response. \nWould you like to see more results?"
        continue = gets.chomp.upcase
    end
    if (continue == "YES")
      return true
    else
      return false
    end
  end

end
