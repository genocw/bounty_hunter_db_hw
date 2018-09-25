require_relative("models/bounty.rb")
require("pry")

Bounty.delete_all()

bounty1 = Bounty.new({
  "name" => "Lucky Luke",
  "bounty_value" => "500",
  "danger_level" => "Medium",
  "favourite_weapon" => "Pistol"
  })

bounty2 = Bounty.new({
  "name" => "Shotgun Sally",
  "bounty_value" => "1000",
  "danger_level" => "High",
  "favourite_weapon" => "Sawn-off Shotgun"
  })

bounty1.save()
bounty2.save()

p Bounty.all()

bounty1.bounty_value = 750
bounty1.update()

binding.pry
nil
