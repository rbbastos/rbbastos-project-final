require 'open-uri'
require 'json'
# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# if Rails.env.development means that this password and email will only work in development mode
LineItem.destroy_all
Product.destroy_all
# DO NOT DESTROY Category.destroy_all # if destroy, fix python script
# Deal.destroy_all
Payment.destroy_all
Order.destroy_all
Customer.destroy_all
# DO NOT DESTROY Province.destroy_all # if destroy, populate again manually
# Province.destroy_all
AdminUser.destroy_all

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

product = Product.new
customer = Customer.new
order = Order.new

['New', 'Recently Added', 'On Sale'].each do |deal|
  Deal.find_or_create_by(name: deal)
end

['All', 'Video Games & Movies', 'Smart Home & Car Electronics', 'Computers & Tablets', 'Musical Instruments', 'TV & Home Theatre'].each do |cat|
  Category.find_or_create_by(name: cat)
end

provinces = {
  Ontario: { gstTax: 0, pstTax: 13 },
  Quebec: { gstTax: 9.975, pstTax: 5 },
  'British Columbia': { gstTax: 7, pstTax: 5 },
  Alberta: { gstTax: 0, pstTax: 5 },
  Manitoba: { gstTax: 7, pstTax: 5 },
  Saskatchewan: { gstTax: 6, pstTax: 5 },
  'Nova Scotia': { gstTax: 0, pstTax: 0 },
  'New Brunswick': { gstTax: 0, pstTax: 0 },
  'Newfoundland and Labrador': { gstTax: 0, pstTax: 15 },
  'Prince Edward Island': { gstTax: 0, pstTax: 15 },
  'Northwest Territories': { gstTax: 5, pstTax: 0 },
  Nunavut: { gstTax: 5, pstTax: 0 },
  Yukon: { gstTax: 5, pstTax: 0 }
}

provinces.each do |k, v|
  Province.find_or_create_by(name: k, gstTax: v[:gstTax], pstTax: v[:pstTax])
end

lineItems = LineItem.new
json = ActiveSupport::JSON.decode(File.read('db/bestbuy4.json'))
# puts json

json.each do |name|
  deal = Deal.order('random()').first
  category = Category.order('random()').first
  product = Product.create!(name: name.values[0],
                            category_id: category.id.to_i,
                            manufacturer: name.values[0].split(' ').first,
                            sellPrice: name.values[1][1..-1].to_d,
                            deal_id: deal.id.to_i)
  downloaded_image = open(name.values[2])
  product.image.attach(io: downloaded_image,
                       filename: name.values[2].split('/').last)

  # product = Product.create!(name: name.values[0],
  #                           category_id: name.values[3].to_i,
  #                           manufacturer: name.values[0].split(' ').first,
  #                           sellPrice: name.values[1][1..-1].to_d,
  #                           deal_id: deal.id.to_i)
  # downloaded_image = open(name.values[2])
  # product.image.attach(io: downloaded_image,
  #                      filename: name.values[2].split('/').last)

  # p.images.attach(io: downloaded_image, filename: filename_to_use_locally)
end
# rand(50..100).times do
#   category = Category.order('random()').first
#   deal = Deal.order('random()').first
#   product = Product.create!(name: Faker::Commerce.product_name,
#                             category_id: category.id.to_i,
#                             manufacturer: Faker::Company.name,
#                             sellPrice: rand(1..1000).to_d,
#                             deal_id: deal.id.to_i)
# end

Faker::Config.locale = 'en-CA'
rand(50..100).times do
  province = Province.order('random()').first
  customer = Customer.create(firstName: Faker::Name.first_name,
                             lastName: Faker::Name.last_name,
                             streetAddress: Faker::Address.street_address,
                             city: Faker::Address.city,
                             country: 'Canada',
                             postalCode: Faker::Address.postcode,
                             phone: Faker::PhoneNumber.phone_number,
                             province_id: province.id.to_i)
  rand(0..3).times do
    order = Order.create(pstTimeOfPurchase: customer.province.gstTax,
                         gstTimeOfPurchase: customer.province.pstTax,
                         customer_id: customer.id.to_i)
    # order = customer.orders
    #                 .build(pstTimeOfPurchase: customer.province.gstTax,
    #                        gstTimeOfPurchase: customer.province.pstTax,
    #                        customer_id: customer.id.to_i)
    #                 .save
    # puts order.id
    p = Product.order('random()').first
    LineItem.create(quantity: rand(1..10),
                    unit_price: p.sellPrice.to_d,
                    product_id: p.id.to_i,
                    order_id: order.id)
  end
end

# rand(30..50).times do
#   o = Order.order('random()').first.id
#   p = Product.order('random()').first
#   LineItem.create(quantity: rand(1..10),
#                   unit_price: p.sellPrice.to_d,
#                   product_id: p.id.to_i,
#                   order_id: o.to_i)
# end

puts "Generated #{Product.count} product."
puts "Generated #{Category.count} categories."
puts "Generated #{Customer.count} customers."
puts "Generated #{Order.count} orders."
puts "Generated #{LineItem.count} lineItems."
