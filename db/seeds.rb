["Tank top", "T-shirt/blouse", "Long sleeve shirt", "Sweater/hoodie", "Shorts", "Long pants/dress pants", "Stockings/leggings/long socks", "Raincoat", "Winter coat", "Sneakers", "Boots", "Sandals"].each do |clothing|
  Clothing.create(clothing_name: clothing)
end

User.create(username: "Raquel", gender: "Female")
