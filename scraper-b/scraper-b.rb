require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

# div_gridprod = 'grid-col grid-product a'

product_names = Array.new
product_links = Array.new
product_prices = Array.new
product_collection = Array.new
collections = Array.new

baseurl = "http://store.{INSERT BASEURL HERE}.com/"

puts "\nWelcome to Product Scraper B\n"

# puts "\nWhich collection? "
# print "#{baseurl}/collections/"
# collection = gets.chomp

basepage = Nokogiri::HTML(open("#{baseurl}"))

puts "\nGetting Collections..."

taxonomies = basepage.css("ul#taxonomies")

menus = taxonomies.css("li[class*='taxonomy-root']")

for n in [1..8]
	menu = menus[n]
	for li in menu.css('li')
		unless li.css('a')[0]['href'] == '0'
			collections.push li.css('a')[0]['href']
			# puts li.css('a')[0]['href']
		end
	end
end

collections.uniq!

for collection in collections
	puts "\nProcessing... #{collection}"

	mainpage = Nokogiri::HTML(open("#{baseurl}#{collection}"))

	# page.css('span[class="last"]').css('a')[0]['href']

	if mainpage.css('span[class="last"]').text == ""
		subpages = 0
		puts "Subpages: " + subpages.to_s

		page = Nokogiri::HTML(open("#{baseurl}#{collection}"))

		products = page.css('ul#products')

		for product in products.css('li')
			product_names.push product.css("span[class='name']").text
			# product_links.push product.css('a[itemprop="name"]')[0]['href']
			product_prices.push /\$(?<price>\d.*)/.match(product.css('span[class="selling-price"]').text)[:price].to_i
			# product_collection.push page.css('li[class="active"]')[0].text
		end
	else
		subpages = /(?<lastpage>\d+)$/.match(mainpage.css('span[class="last"]').css('a')[0]['href'])[:lastpage].to_i
		puts "Subpages: " + subpages.to_s

		puts "Page... "

		for pagenum in (1..subpages)
			print "#{pagenum}... "
			page = Nokogiri::HTML(open("#{baseurl}#{collection}?page=#{pagenum}"))

			products = page.css('ul#products')

			for product in products.css('li')
				# Product Name

				# products.css('li').each{|product| product_names.push product.css("span[class='name']").text}
				product_names.push product.css("span[class='name']").text

				# Product Link

				# products.css('li').each{|product| product_links.push product.css('a[itemprop="name"]')[0]['href']}
				# product_links.push product.css('a[itemprop="name"]')[0]['href']

				# Price

				# products.css('li').each{|product| product_prices.push product.css('span[class="selling-price"]').text}
				product_prices.push /\$(?<price>\d.*)/.match(product.css('span[class="selling-price"]').text)[:price].to_f

				# Collection

				# products.each{|product| product_collection.push page.css('li[class="active"]')[0].text}
				# product_collection.push page.css('li[class="active"]')[0].text
			end
		end
	end
end

product_names.push "Product Name"
# product_links.push "URL"
product_prices.push "Price (USD)"
# product_collection.push "Collection"

# puts product_names.length
# puts product_links.length
# puts product_prices.length
# puts product_collection.length

data = [product_names, product_prices].transpose

data.uniq!

puts "\n\nAll done! What suffix would you like to add to this file?"
puts "(Note: Your suffix plus '.csv' will be added to the end of the filename)"
print "\nSuffix: "
suffix = gets.chomp

puts "\n** Saved file 'product_data_#{suffix}.csv' **"

File.open("product_data_#{suffix}.csv", "w") {|f| f.write(data.reverse.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join(""))}

puts "\nThis was a triumph! Enjoy your data.\n\n    ^_^\n\n"