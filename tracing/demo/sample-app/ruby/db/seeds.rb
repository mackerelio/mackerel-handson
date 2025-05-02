require 'faker'

1_000.times do
  Category.find_or_create_by!(name: Faker::Commerce.department)
end

1_000.times do
  Product.find_or_create_by!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    price: Faker::Commerce.price,
    category: Category.order('RAND()').first
  )
end
