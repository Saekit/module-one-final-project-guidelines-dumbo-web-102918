require 'pry'

# ["Tank top", "T-shirt/blouse", "Long sleeve shirt", "Sweater/hoodie", "Shorts", "Long pants/dress pants", "Stockings/leggings/long socks", "Raincoat", "Winter coat", "Sneakers", "Boots", "Sandals"].each do |clothing|
#   Clothing.create(clothing_name: clothing)
# end

User.destroy_all
Clothing.destroy_all


User.create(username: "Raquel")

clothing = {
  tops: {"tshirt" => [65, 110], "tanktop" => [70, 110], "long sleeve shirt" => [-20, 60], "dress" => [50, 110], "sweater" => [-20, 60], "hoodie" => [-20, 60], "thermal top" => [-20, 40], "light jacket" => [40, 60], "raincoat" => [40, 60], "wintercoat" => [-20, 40]},
  bottoms: {"shorts" => [60, 110], "skirt" => [60, 110], "dress pants" => [60, 80], "jeans" => [-20, 110], "thermal underwear" => [-20, 30], "leggings" => [40, 60]},
  footwear: {"dress shoes" => [30, 80], "boots" => [-20, 50], "sandals" => [65, 110], "sneakers" => [40, 80]},
  accessories: {"sunglasses" => [60, 110], "hat" => [60, 110], "beanie" => [-20, 60], "scarf" => [-20, 60]}
}
clothingTemp= clothing[:tops].map do |top, temp|
    Clothing.create(clothing_name: top, min_temp:temp[0], max_temp:temp[1])
  end


clothingTemp= clothing[:bottoms].map do |bottoms, temp|
  Clothing.create(clothing_name: bottoms, min_temp:temp[0], max_temp:temp[1])
end


clothingTemp= clothing[:footwear].map do |footwear, temp|
  Clothing.create(clothing_name: footwear, min_temp:temp[0], max_temp:temp[1])
end

clothingTemp= clothing[:accessories].map do |accessories, temp|
  Clothing.create(clothing_name: accessories, min_temp:temp[0], max_temp:temp[1])
end
# accessories = clothing[:accessories].keys.each { |clothing| Clothing.create(clothing_name: clothing)}
