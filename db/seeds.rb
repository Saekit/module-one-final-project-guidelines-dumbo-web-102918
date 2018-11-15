require 'pry'

# when seed, will destroy info and recreate
User.destroy_all
Clothing.destroy_all


User.create(username: "Raquel")

clothing = {
  tops: {"T-Shirt" => [60, 110], "Tanktop" => [70, 110], "Long sleeve shirt" => [-20, 65], "Dress" => [50, 110], "Sweater" => [-20, 60], "Hoodie" => [-20, 65], "Thermal top" => [-20, 40], "Light jacket" => [40, 60], "Raincoat" => [40, 60], "Wintercoat" => [-20, 40]},
  bottoms: {"Shorts" => [60, 110], "Skirt" => [60, 110], "Dress pants" => [60, 80], "Jeans" => [-20, 110], "Thermal underwear" => [-20, 30], "Leggings" => [40, 60]},
  footwear: {"Dress shoes" => [30, 80], "Boots" => [-20, 50], "Sandals" => [65, 110], "Sneakers" => [40, 80]},
  accessories: {"Sunglasses" => [60, 110], "Hat" => [60, 110], "Beanie" => [-20, 60], "Scarf" => [-20, 60]}
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
