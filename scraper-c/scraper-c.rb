require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

# div_gridprod = 'grid-col grid-product a'

product_names = Array.new
product_links = Array.new
product_prices = Array.new
product_vendors = Array.new

puts "\nWelcome to Product Scraper C\n"

# puts "\nEnter URL prefix: "
# url = gets.chomp

baseurl = "http://www.{INSERT BASEURL HERE}.com/shop/page/"

puts "\nHow many pages? "
pages = gets.chomp

puts "\nProcessing page "

for number in (1..pages.to_i)
	print " #{number} "

	page = Nokogiri::HTML(open("#{baseurl}#{number}/"))

	products = page.css("div[class='grid-col grid-product']")

	print "."

	# Name
	# puts products.css('a')[0]['title']

	products.each{|product| product_names.push product.css('a')[0]['title']}

	print "."

	# Link
	# puts products.css('a')[0]['href']

	products.each{|product| product_links.push product.css('a')[0]['href']}

	print "."

	# Price
	# puts products.css("div[class='price-circle large-price-circle']").text

	# products.each{|product| product_prices.push product.css("div[class='price-circle large-price-circle']").text}
	# products.each{|product| product_prices.push product.css("div[class*='price-circle']").text}

	products.each{|product| product_prices.push /\$(?<price>\d.*)/.match(product.css("div[class*='price-circle']").text)[:price].to_f}

	# Vendor
	# puts products.css("div[class='item-subheading']").css('a').text

	products.each{|product| product_vendors.push product.css("div[class='item-subheading']").css('a').text}
end

product_names.push "Product Name"
product_links.push "URL"
product_prices.push "Price (USD)"
product_vendors.push "Vendor"

data = [product_names, product_links, product_prices, product_vendors].transpose

puts "\n\nAll done! What would you like to call this file?"
puts "(Note: '.csv' will be added to the end)"
print "\nFilename: "
filename = gets.chomp

puts "\n** Saved file '#{filename}.csv' **"

File.open("#{filename}.csv", "w") {|f| f.write(data.reverse.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join(""))}

puts "\nThis was a triumph! Enjoy your data.\n\n    ^_^\n\n"