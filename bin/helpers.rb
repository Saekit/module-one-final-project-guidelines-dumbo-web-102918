require 'pry'
require 'Geocoder'
require 'RestClient'

def welcome
  puts "Welcome to What Should I Wear Today?"
end

def username
  puts "Please enter a username"
  username = gets.chomp
  puts "Welcome #{username}"
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
    # closet_menu
  when 3
    see_closet(user)
  end

end




def current_temp(user)
  system "clear"
  puts "Please enter a city, state"
  input = gets.chomp

  results = Geocoder.search("#{input}")
  lat_and_lon = results.first.coordinates
  resp_string = RestClient.get("https://api.darksky.net/forecast/eb71c14bc64ff622d7d592881b708917/#{lat_and_lon[0]},#{lat_and_lon[1]}")
  resp_hash = JSON.parse(resp_string.body)
   # summary = resp_hash["daily"]["data"][0]["summary"]
   # temperatureHigh = resp_hash["daily"]["data"][0]["temperatureHigh"]
   # temperatureLow = resp_hash["daily"]["data"][0]["temperatureLow"]
   # chance_of_rain = resp_hash["daily"]["data"][0]["precipProbability"]
   # weather_icon = resp_hash["daily"]["data"][0]["icon"]
   currentTemperature = resp_hash["currently"]["temperature"]
   # currentTemperature
   # binding.pry
   stuff = user.clothings.select do |clothing|
    clothing.min_temp < currentTemperature && clothing.max_temp > currentTemperature
    # binding.pry
  end
    stuff2 = stuff.map {|clothes| clothes.clothing_name}
    puts "Okay, it's #{currentTemperature}F in #{input.capitalize} right now..."
    puts "Rummaging through your clothes...😉"
    sleep(5)
  if stuff.count == 0
    system 'clear'
    puts "You have nothing to wear! Let's go shopping...🤑"
    menu
  else
    system 'clear'
    puts "Here's some good options for today 😎"
    puts stuff2.each {|clothes| clothes}
    menu
  end
end

def create_closet(user)
  system "clear"
  prompt = TTY::Prompt.new
  closet = prompt.multi_select("What clothing do you own?", Clothing.clothingNames)
  user.clothing_ids = closet
  menu
end

def closet(user)
  user.clothings.map {|clothing| "#{clothing.clothing_name}"}
end




def see_closet(user)
  system "clear"
  puts "Here is your closet:"
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
