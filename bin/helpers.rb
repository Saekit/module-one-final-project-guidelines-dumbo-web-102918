require 'pry'
require 'geocoder'
require 'rest-client'

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
  when 2
    create_closet(user)
  when 3
    see_closet(user)
  end

end

def create_closet(user)
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


# def coordinates
#   results = Geocoder.search("Brooklyn, NY")
#   lat_and_lon = results.first.coordinates
#   resp_string = RestClient.get("https://api.darksky.net/forecast/eb71c14bc64ff622d7d592881b708917/#{lat_and_lon[0]},#{lat_and_lon[1]}")
#   resp_hash = JSON.parse(resp_string.body)
# end
#
# coordinates
