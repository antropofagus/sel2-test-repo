CUSTOMER = {
    :name => Faker::Name.first_name,
    :lastname => Faker::Name.last_name,
    :address => Faker::Address.street_address,
    :postcode => Faker::Address.postcode,
    :country => Faker::Address.default_country,
    :city => Faker::Address.city,
    :phone => "+7#{Faker::Number.number(10)}",
    :email => Faker::Internet.email,
    :password => '12345678'

}