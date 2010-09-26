Plant.define :profile do |profile|
  profile.password = "BREIZH!"
end

Plant.define :adress do |adress|
  adress.number = 17
  adress.street = "rue royale"
end

Plant.define :user do |user|
  user.name  = "Zorro"
  user.age = 800
  user.profile = Plant.association(:profile)
  user.adresses = [Plant(:adress)]
end

Plant.define :customer do |customer|
end

