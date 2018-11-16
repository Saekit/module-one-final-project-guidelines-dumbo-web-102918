require 'pry'
require 'Geocoder'
require 'RestClient'
require 'colorize'
require 'colorized_string'

def welcome
  system 'clear'
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
    menu.choice 'Delete closet', 4
    menu.choice 'Exit', 5
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
  when 4
    delete_closet(user)
  end

end




def current_temp(user)
  system "clear"
  puts "Where would you like to go?".colorize(:cyan)
  input = gets.chomp.strip

  results = Geocoder.search("#{input}")
  if results.empty?
    puts "Did you spell that right?"
    menu
  else
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
      answer = gets.chomp.downcase.strip
      if answer == "a shadow"
        puts <<-HEREDOC
        ----.:--:-.-`---.:


          `
         +.
       .+`
      :/   -`
     +-  `+`
    +-  .+
   -+  `+
   s   o                                .-:/+oossssssso++/:-.                          -`
  `o  :-                           .:+syyyyyyyyyyyyyyyyyyyyyyys+:.                      :.
  :/  o                        `:oyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy+:`                   :.
  /: `o                     `:oyyyyyyyyyyyyhdNy/+hyyyyyyyyyyyyyyyyyyyyo:`                 +
  ./ -/      `-/+oooo/.   .+yyyyyyyyyyyyyho`+-   /hhhyyyyyyyyyyyyyyyyyyyy+.               `+
   / -/    :osoooooooos/.oyyyyyyyyyyyyyyy+ -/+ossssssssyyhs+/:::/oyhyyyyyyy+.              :.
   - :/  :sooos+/+soooodyyyyyyyyyyyyyyyydosoooooooooooooos.      /Mdhyyyyyyyy/`             o
     .o osooy/`   +soohhyyyyyyyyyyyyyyhyooooooossssooooooos/.    `:`dyyyyyyyyys-            +.
      y-ysoy.    :yoohhyyyyyyyyyyyyyyhyyyyyyyyyyyyyyhhyyyysoso/-`  +hyyyyyyyyyyy/           `+
      sohoos    .hooydyyyyyhhhhhyyyydsyyyyyyyyhdddyyhddhyyyhhysossshyyyyyyyyyyyyy+          `s`.
      .dyooy+`  osoodyyyhhysooosdyyydoyyyyyyyyNMMMmNMMMMNyyyyyhyooohyyyyyyyyyyyhhho/:       .y  -
      +s/yoooy+ yooosyyyooossooosdyydyohyyyyyh+/o+/+shhyyyyyyyhsooyhyyyyyyyyhhysoooooyo.     y/..-
     /-.dsooooy/soooooooshhhdyooodyyydoshyyyyhooosyyyyyyyyyyhyooohhyyyyyyyyyhooooooooooy/    y o``
 /oood+hsdoooso`shooooydhyyydoooodyyydsooyyyyyyyyyyyyyyyyhyyoooydyyyyyyyyyyhsoooyyyysooos+  `s /:
 :oshdymosyooso/yhhhhhyyyyyydoooomyyyydsooshyyyyyyyyyyhhyooooydyyyyyyyyyyyyhhooshyyyhhooos+ +:`/-.
`://yyhysooyoyysdyyyyyyyyyyydooooshhhyhhyooosyyyyyyyysoooosydyyhhhhhhhyyyyyydsoodyyyy/hoooyoy /` :
-osshyshdoyms+`hsdyyyyyyyyyydsooosyyso+:osysoooooooooosyyso/ohyooooooshhyyyyydsosdyyy/+sooods+y- `
   `+hssyyysy` ohyyyyyyyyyyyydhooosyyshy/:/o+osssssoos+/::/dhsoooooooooyhyyyyydsosdhhsosoodyodssy+
   -oho:oyss`  +yyyyyyyyyyyyyyyhhhmdhyoossh/::+s/::::hs/:::sdooooydhdyoodyyyyyydyohyosssodhoyhyossy`
     `/ -:.    :yyyyyyyyyyyyyyyyyhyoooooys/+ossoyo:::yosso+/hooyhhyyydyoodyyyyyydyhsy/ ddhysdsso/yoo
               .yyyyyyyyyyyyyyyyydoooooysssooooooosooysoooosyydyyyyyyydyoohhyyyyydohh.+hosydy+oh`yso
                oyyyyyhddhhyyyyydsoooooooooooooooooooooooooooohyyyyyyyydyooshhhhyoods-/sy+ms+ooh `-
                .yhyyhhyyyyyyyyydooooooooooooooooooooooooooooodyyyyyyyyydyoooooooohh` /sodso hs+
                -o-/hhhyyyyyyyydsooooooooooooooooooooooooooooodyyyyyyyyyyhhyooosyhh:   //:-  -.
                +// `:yyyyyyyyydoooooooooooooooooooooooooooooyhyyyyyyyyyyyyyhhhhyy+  .+.
               .:-:ohyyyyyyyyyydooooooooooooooooooooooooooooodyyyyyyyyyyyyyyyyyyy+ .:-
              -: o  +yyyhhhhyhhmsssssooooooooooooooooooooooosdyhhyyyyyyyyyyyyyyy/`.`
              o  +``:+/-.`       ``..--:://+ooossssyyyyyyssodyhhdhyhhyyyyyyyyys-
              ::` -:. `/`   /+ --                     ``.-:::/+osydddddddhhyy+`
                :+--`  od. /N.ydm    :mN.    :hh`    /o`    `      `-/oydhmh+/
                o       yd+N:h+-N   .N:ys   od.N/   hysh   ohm.  o:    - -++o+:-
               -/       `mm-sy:+N   yy oh  od` ys  +d -M` -m`oy   y+  /y :`:-o:y-
               ::      .dh`+/.-+m  :N++yd .N+++dy  m+..M- sy`/m   `d/.m.oy+o `s:
                s     +N+ /:   /d `m:  +d so   sy .N::/m+ ho:oM    `dm--d`d`  +.
                .+.   .`  `    oy o+   +d`m`   sy +y   ho d. -M`   /d-`h.o:   s
                  -::.         -- -    /d++    sy d`   sy`d  .M` :hs` s- .  .+-
                     `-::::-`           ``     ho`:    +d`o  /m:hs. ./`.+.:/:
                           .:::::::-.`         -`      `-    `-    `:/:::-
                                   `.-:::::::::/:::::::::::::::::::-`

HEREDOC
      else
        puts "Nope, that's not it!"
      end
    when "wind"
      puts "Hold on to your hat! 💨".colorize(:cyan)
    when "cloudy"
      puts "It's cloudy, but keep your head up! 😊".colorize(:cyan)
    end
    menu
  end
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
  if user.clothings.count == 0
    puts "You have no clothes!".colorize(:red)
  else
    puts "Here is your closet:".colorize(:cyan)
  end
  puts closet(user)
  menu
end


def delete_closet(user)
  user.clothings.destroy_all
  menu
end
