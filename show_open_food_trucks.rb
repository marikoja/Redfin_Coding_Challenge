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
    @foodTruckList = []
    if res.is_a?(Net::HTTPSuccess)
      JSON.parse(res.body).each do |truck|
        if truck["end24"] >= hour
          @foodTruckList << truck
        end
      end
    else
      raise "HTTP request failed"
    end

    # Sort responses alphabetically
    @foodTruckList.sort_by! { |truck| truck["applicant"]}
  end

  def print_trucks

    if (@foodTruckList.length == 0)
      puts "No food trucks found."
    else
      totalCnt = 0
      dispCnt = 0
      displayMore = true

      # loop while there are still more food trucks to display and
      # we've displayed less than 10 for this current run and the
      # user still wants to see more food truck results
      while (totalCnt < @foodTruckList.length && dispCnt < 10 && displayMore == true)
        self.search_output(totalCnt)
        totalCnt += 1
        dispCnt += 1

        # if there are still more food trucks to display and we've just displayed a set of 10,
        # then prompt the user if they want to see more food truck results
        if (totalCnt < @foodTruckList.length && dispCnt == 10)
          dispCnt = 0
          displayMore = self.ask_display_more
        end
      end
    end
  end

  # Print out responses
  def search_output(index)
    if @foodTruckList[index]["applicant"] && @foodTruckList[index]["location"]
      puts "NAME: " + @foodTruckList[index]["applicant"] + "\n\tADDRESS: " + @foodTruckList[index]["location"]
    elsif @foodTruckList[index]["applicant"] && !@foodTruckList[index]["location"]
      puts "NAME: " + @foodTruckList[index]["applicant"] + "\n\tADDRESS: "+ "location unknown"
    elsif !@foodTruckList[index]["applicant"] && @foodTruckList[index]["location"]
      puts (index + 1).to_s + ") " + @foodTruckList[index]["optionaltext"] + "\n\tADDRESS: "+ @foodTruckList[index]["location"]
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
