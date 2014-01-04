require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

# div_gridprod = 'grid-col grid-product a'

product_names = Array.new
product_links = Array.new
product_prices = Array.new
product_collection = Array.new

baseurl = "http://www.{INSERT BASEURL HERE}.com"

collections = ["array","of","product","collections"]

puts "\nWelcome to Product Scraper A\n"

puts "\nProcessing..."

for collection in collections
	print " #{collection}..."

	page = Nokogiri::HTML(open("#{baseurl}/collections/#{collection}"))

	products = page.css("div[class='product cf']")

	# Product Name
	# products.css("div[class='product-image']").css('img')[0]['alt']

	# RegExp to match product name text: \w.+(?= /)

	products.each{|product| product_names.push product.css('img')[0]['alt']}


	# Product Link
	# products.css("div[class='product-image']").css('a')[0]['href']

	products.each{|product| product_links.push baseurl + product.css("div[class='product-image']").css('a')[0]['href']}
	# products.each{|product| puts baseurl + products.css("div[class='product-image']").css('a')[0]['href']}


	# Price
	# 
	# RegExp to match product price: \$\d.+

	# products.each{|product| product_prices.push product.css("div[class='price-circle large-price-circle']").text}
	products.each do |product|
		if /\$(?<price>\d.*)/.match(product.css("div[class='product-title']").css('a').text) == nil
			product_prices.push 0.00
		else
			product_prices.push /\$(?<price>\d.*)/.match(product.css("div[class='product-title']").css('a').text)[:price].to_f
		end
	end
	# products.each{|product| puts /(?<price>\$\d.+)/.match(product.css("div[class='product-title']").css('a').text)[:price]}


	# Collection
	# page.css("div[class*='collection-header']").css('p')[0].text

	products.each{|product| product_collection.push /(?<collection>^\w.+)(?= \()/.match(page.css("div[class*='collection-header']").css('p')[0].text)}

	# sleep(2)
end

product_names.push "Product Name"
product_links.push "URL"
product_prices.push "Price (USD)"
product_collection.push "Collection"

data = [product_names, product_links, product_prices, product_collection].transpose

puts "\n\nAll done! What suffix would you like to add to this file?"
puts "(Note: Your suffix plus '.csv' will be added to the end of the filename)"
print "\nSuffix: "
suffix = gets.chomp

puts "\n** Saved file 'product_data_#{suffix}.csv' **"

File.open("product_data_#{suffix}.csv", "w") {|f| f.write(data.reverse.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join(""))}

puts "\nThis was a triumph! Enjoy your data.\n\n    ^_^\n\n"