require 'pry'
require 'Geocoder'
require 'RestClient'
require 'colorize'
require 'colorized_string'

def welcome
  puts "Welcome to What Should I Wear Today?".colorize(:cyan)
end

def username
  puts "What's your name?".colorize(:cyan)
  username = gets.chomp
  puts "Welcome #{username}".colorize(:cyan)
  User.find_or_create_by(username: username)
end

def menu
  prompt = TTY::Prompt.new
  prompt.select("What would you like to do?") do |menu|
    menu.enum '.'

    menu.choice 'What should I wear?', 1
    menu.choice 'Create or edit closet', 2
    menu.choice 'See closet', 3
    menu.choice 'Exit', 4
  end

end

def delegate(choice, user)
  case choice
  when 1
    current_temp(user)
  when 2
    create_closet(user)
  when 3
    see_closet(user)
  end

end




def current_temp(user)
  system "clear"
  puts "Where would you like to go?".colorize(:cyan)
  input = gets.chomp

  results = Geocoder.search("#{input}")
  lat_and_lon = results.first.coordinates
  resp_string = RestClient.get("https://api.darksky.net/forecast/eb71c14bc64ff622d7d592881b708917/#{lat_and_lon[0]},#{lat_and_lon[1]}")
  resp_hash = JSON.parse(resp_string.body)
   # summary = resp_hash["daily"]["data"][0]["summary"]
   # temperatureHigh = resp_hash["daily"]["data"][0]["temperatureHigh"]
   # temperatureLow = resp_hash["daily"]["data"][0]["temperatureLow"]
   # chance_of_rain = resp_hash["daily"]["data"][0]["precipProbability"]
   weather_icon = resp_hash["daily"]["data"][0]["icon"]
   currentTemperature = resp_hash["currently"]["temperature"]
   # currentTemperature
   # binding.pry
   stuff = user.clothings.select do |clothing|
    clothing.min_temp < currentTemperature && clothing.max_temp > currentTemperature
    # binding.pry
  end
    stuff2 = stuff.map {|clothes| clothes.clothing_name}
    puts "Okay, it's #{currentTemperature}F with #{weather_icon} in #{input.capitalize} right now...".colorize(:cyan)
    sleep(2)
    puts "Rummaging through your clothes...😉".colorize(:cyan)
    sleep(5)
  if stuff.count == 0
    puts "You have nothing to wear! Let's go shopping...🤑".colorize(:cyan)
    menu
  else
    puts "Here's some good options for today 😎".colorize(:cyan)
    puts stuff2.each {|clothes| clothes}
    case weather_icon
    when "rain"
      puts "Don't get wet, bring an 🌂".colorize(:cyan)
    when "clear-day"
      puts "Today is the day for 🕶".colorize(:yellow)
    when "partly-cloudy-day"
      puts "Enjoy your day! 🌤".colorize(:yellow)
    when "partly-cloudy-night"
      puts "Enjoy your evening! ⛅️".colorize(:cyan)
    when "snow"
      puts "Amir says: 'Buy a fur cap!'".colorize(:cyan)
    when "fog"
      puts "You've unlocked a riddle! Solve it to get a prize:".colorize(:red)
      puts "Only one color, but not one size,".colorize(:yellow)
      puts "Stuck at the bottom, yet easily flies,".colorize(:yellow)
      puts "Present in sun, but not in rain,".colorize(:yellow)
      puts "Doing no harm, and feeling no pain.".colorize(:yellow)
      puts "What am I?".colorize(:yellow)
      answer = gets.chomp.downcase
      if answer == "a shadow"
        puts "YES!"
      else
        puts "Sorry!"
      end
    when "wind"
      puts "Hold on to your hat! 💨".colorize(:cyan)
    when "cloudy"
      puts "It's cloudy, but keep your head up! 😊".colorize(:cyan)
    end
    menu
  end
end

def create_closet(user)
  system "clear"
  prompt = TTY::Prompt.new
  closet = prompt.multi_select("What clothing do you own?".colorize(:cyan), Clothing.clothingNames)
  user.clothing_ids = closet
  menu
end

def closet(user)
  user.clothings.map {|clothing| "#{clothing.clothing_name}"}
end




def see_closet(user)
  system "clear"
  puts "Here is your closet:".colorize(:cyan)
  puts closet(user)
  menu
end
#
# def closet_menu
#   prompt = TTY::Prompt.new
#   prompt.select("What would you like to do?") do |menu|
#     menu.enum '.'
#
#     menu.choice 'Tops', 1
#     menu.choice 'Bottoms', 2
#     menu.choice 'Footwear', 3
#     menu.choice 'Accessories', 4
#     menu.choice 'Back', 5
# end
#
# def tops_closet(user)
#   prompt = TTY::Prompt.new
#   closet = prompt.multi_select("What tops do you own?", Clothing.clothingNames)
#   user.clothing_ids = closet
#   closet_menu
# end
#
# def bottoms_closet(user)
#   prompt = TTY::Prompt.new
#   closet = prompt.multi_select("What bottoms do you own?", Clothing.clothingNames)
#   user.clothing_ids = closet
#   closet_menu
# end
#
# def footwear_closet(user)
#   prompt = TTY::Prompt.new
#   closet = prompt.multi_select("What footwear do you own?", Clothing.clothingNames)
#   user.clothing_ids = closet
#   closet_menu
# end
#
# def accessories_closet(user)
#   prompt = TTY::Prompt.new
#   closet = prompt.multi_select("What accessories do you own?", Clothing.clothingNames)
#   user.clothing_ids = closet
#   closet_menu
# end
#
# def closet_delegate(choice, user)
#   case choice
#   when 1
#     tops_closet
#   when 2
#     bottoms_closet
#   when 3
#     footwear_closet
#   when 4
#     accessories_closet
#   when 5
#     menu
#   end
#
# end
#
# def coordinates
#   results = Geocoder.search("Brooklyn, NY")
#   lat_and_lon = results.first.coordinates
#   resp_string = RestClient.get("https://api.darksky.net/forecast/eb71c14bc64ff622d7d592881b708917/#{lat_and_lon[0]},#{lat_and_lon[1]}")
#   resp_hash = JSON.parse(resp_string.body)
# end
#
# coordinates
