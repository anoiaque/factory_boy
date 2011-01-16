Plant.sequence :email do |n|
  "incognito#{n}@kantena.com"
end

Plant.define :profile do |profile|
  profile.password = "BREIZH!"
end

Plant.define :address do |address|
  address.number = 17
  address.street = "rue royale"
end

Plant.define :user do |user|
  user.name  = "Zorro"
  user.age = 800
  user.profile = Plant.association(:profile)
  user.addresses = [Plant.association(:address)]
end

Plant.define :customer do |customer|
end

