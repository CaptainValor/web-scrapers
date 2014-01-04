require 'nokogiri'
require 'rubygems'
require 'open-uri'
require 'csv'
require 'chronic'

# Input

puts "\nWelcome to Product Scraper D\n"

# print "\nStart scraping when? "
# startime = Chronic.parse(gets.chomp)

# print "\nInterval between scrapes (in minutes): "
# intervalmins = gets.chomp.to_i

# print "\nStop scraping when? "
# stoptime = Chronic.parse(gets.chomp)

intervalmins = 20
stoptime = Chronic.parse('tomorrow at 1am')

# cartcounts = {}
# buycounts = {}
counts = {}

# cartindex = []
# buyindex = []

itemindex =[]

regex_name = /\b(?<title>\w.*\w)\b/
regex_price = /\$(?<price>\d.*)/
# puts regex_name.match(item.css('div[class="item-heading"] a').text)[:title]


# feeditems.css('div[class*="activity-item"]').each {|item| puts regex_name.match(item.css('div[class="item-heading"] a').text)[:title]}

# item['class'] == "activity-item action-added_to_cart"
# item['class'] == "activity-item action-purchased"

# cartitems = feeditems.css('div[class*="activity-item action-added_to_cart"]')
# buyitems = feeditems.css('div[class*="activity-item action-purchased"]')

# def getprice(item)
# 	itemurl = item.css('div[class="item-heading"] a')['href']
# 	itempage = Nokogiri::HTML(open(itemurl))
# 	itemprice = /\$(?<price>\d.*)/.match(itempage.css('div[class="price-box"]').text)[:price].to_f

# 	productinfo['price'] = itemprice
# end

while Time.now < stoptime
	puts "\n"
	page = Nokogiri::HTML(open("http://www.{INSERT BASEURL HERE}.com/"))
	feeditems = page.css('div[class*="activity-item"]')

	for item in feeditems
		productname = regex_name.match(item.css('div[class="item-heading"] a').text)[:title]

		if counts[productname] == nil
			productinfo = {}
			productinfo['name'] = productname
			productinfo['cartcount'] = 0
			productinfo['buycount'] = 0
			productinfo['price'] = 0.0

			counts[productname] = productinfo
			itemindex.push productname
			
			itemurl = item.css('div[class="item-heading"] a')[0]['href']
			itempage = Nokogiri::HTML(open(itemurl))
			itemprice = /\$(?<price>\d.*)/.match(itempage.css('div[class="price-box"]').text)[:price].to_f

			productinfo['price'] = itemprice

			puts "Added Item: " + productinfo['name'] + " $" + productinfo['price'].to_s
		end

		if item['class'] == "activity-item action-added_to_cart"
			counts[productname]['cartcount'] += 1

			puts "Incremented Cart Item: " + productname
		else
			counts[productname]['buycount'] += 1

			puts "Incremented Purchase Item: " + productname
		end
	end

	puts "\nWaiting for #{intervalmins.to_s} minutes..."
	sleep(60*intervalmins)
end


# for item in cartitems
# 	productname = regex_name.match(item.css('div[class="item-heading"] a').text)[:title]

# 	if cartcounts[productname] == nil
# 		productinfo = {}

# 		productinfo['name'] = productname
# 		productinfo['count'] = 1
# 		cartcounts[productname] = productinfo
# 		cartindex.push productname

# 		puts "Added Cart Item: " + productname
# 	else
# 		cartcounts[productname]['count'] += 1
# 		puts "Incremented Cart Item: " + productname
# 	end
# end

# puts "\nCART COUNTS\n\n"
puts "\nCOUNTS\n\n"

for item in itemindex
	puts counts[item]['name'] +  " $" + counts[item]['price'].to_s
	puts 'Cart: ' + counts[item]['cartcount'].to_s
	puts 'Purchased: ' + counts[item]['buycount'].to_s
end

# for item in cartindex
# 	print cartcounts[item]['name']
# 	puts ' - ' + cartcounts[item]['count'].to_s
# end

puts "\n"

# for item in buyitems
# 	productname = regex_name.match(item.css('div[class="item-heading"] a').text)[:title]

# 	if buycounts[productname] == nil
# 		productinfo = {}

# 		productinfo['name'] = productname
# 		productinfo['count'] = 1
# 		buycounts[productname] = productinfo
# 		buyindex.push productname

# 		puts "Added Purchased Item: " + productname
# 	else
# 		buycounts[productname]['count'] += 1
# 		puts "Incremented Purchase Item: " + productname
# 	end
# end

# puts "\nPURCHASE COUNTS\n\n"

# for item in buyindex
# 	print buycounts[item]['name']
# 	puts ' - ' + buycounts[item]['count'].to_s
# end

# MANUAL OUTPUT

# puts "\n\nAll done! What suffix would you like to add to this file?"
# print "\nSuffix: "
# suffix = gets.chomp


# AUTO OUTPUT

suffix = Time.now.strftime("%Y%m%d_%H%M%S").to_s

data_names = Array.new
data_prices = Array.new
data_cart = Array.new
data_buy = Array.new

for item in itemindex
	data_names.push counts[item]['name']
	data_prices.push counts[item]['price']
	data_cart.push counts[item]['cartcount']
	data_buy.push counts[item]['buycount']
end

data_names.push "ProductName"
data_prices.push "Price_USD"
data_cart.push "CartCount"
data_buy.push "BuyCount"

data = [data_names, data_prices, data_cart, data_buy].transpose

File.open("product_sales_data_#{suffix}.csv", "w") {|f| f.write(data.reverse.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join(""))}

puts "\n** Saved file 'product_sales_data_#{suffix}.csv' **\n"


# feeditems.css('div[class*="activity-item action-added_to_cart"]').each {|item| puts regex_name.match(item.css('div[class="item-heading"] a').text)[:title]}
# feeditems.css('div[class*="activity-item action-purchased"]').each {|item| puts regex_name.match(item.css('div[class="item-heading"] a').text)[:title]}

# feeditems.css('div[class*="activity-item action-added_to_cart"]').each {|item| cartcounts[regex_name.match(item.css('div[class="item-heading"] a').text)[:title]] = 1}
# feeditems.css('div[class*="activity-item action-purchased"]').each {|item| puts regex_name.match(item.css('div[class="item-heading"] a').text)[:title]}