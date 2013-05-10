Given(/^a full compliment of active and sold trailers$/) do
  Fabricate(:product, size: 25, year: 2010, price_last: 20000, days_active: 10, removed_at: nil)
  Fabricate(:product, size: 25, year: 2001, price_last: 40000, days_active: 20, removed_at: nil)
  Fabricate(:product, size: 25, year: 2002, price_last: 60000, days_active: 60, removed_at: nil)
  Fabricate(:product, size: 25, year: 2003, price_last: 50000, days_active: 10, removed_at: 1.months.ago)
  Fabricate(:product, size: 25, year: 2004, price_last: 25000, days_active: 00, removed_at: 1.months.ago)
  Fabricate(:product, size: 25, year: 2005, price_last: 75000, days_active: 50, removed_at: 2.months.ago)
  Fabricate(:product, size: 34, year: 2006, price_last: 60000, days_active: 60, removed_at: nil)
end

When(/^I visit the homepage$/) do
  visit('/')
end

Then(/^I should see a summary with correct values$/) do
  page.all('table tbody tr').count.should == 2

  page.find(:xpath, '//tbody/tr[1]/td[1]').should have_content('25')
  page.find(:xpath, '//tbody/tr[1]/td[2]').should have_content('3')
  page.find(:xpath, '//tbody/tr[1]/td[3]').should have_content('$40,000.00')
  page.find(:xpath, '//tbody/tr[1]/td[4]').should have_content('30')
  page.find(:xpath, '//tbody/tr[1]/td[5]').should have_content('3')
  page.find(:xpath, '//tbody/tr[1]/td[6]').should have_content('$50,000.00')
  page.find(:xpath, '//tbody/tr[1]/td[7]').should have_content('20')
end

Then(/^I should see links to each individual length page$/) do
  page.find_link('25')['href'].should have_content(length_path(length: '25', order: 'year'))
end

When(/^I visit the 25 footer length page$/) do
  visit(length_path(length: '25', order: 'year'))
end

Then(/^I should see the 25 foot trailers$/) do
  page.find(:xpath, '//tr[3]/td[2]').should have_content('20')
  page.find(:xpath, '//tr[3]/td[3]').should have_content('2001')
end


When(/^I visit the (\d+) footer length sorted by price page$/) do |arg1|
  visit(length_path(length: '25', order: 'price'))
end

Then(/^I should see the cheapest trailer listed first$/) do
  page.find(:xpath, '//tr[3]/td[5]').should have_content('$20,000.00')
  page.find(:xpath, '//tr[3]/td[3]').should have_content('2010')
end



Given(/^an active trailer with full attributes$/) do
  Fabricate(:product, size: 25, year: 2001, price_last: 40000, price: 40000, days_active: 20, removed_at: nil, title: "2001 25' Safari", description: "Trailer is in good condition", condition: 'Good', make_model: 'Safari', external_id: '11111', location: 'Cortez, Colorado')
end

When(/^I visit that trailers product page$/) do
  visit product_path(Product.last)
end

Then(/^I should see a message that it is still actively listed on airstreamclassifieds$/) do
  page.should have_content('Active Listing on airstreamclassifieds.com')
  page.should have_content('http://www.airstreamclassifieds.com/showproduct.php?product=11111')
end

Then(/^I should see all archived attributes the are available$/) do
  page.should have_content("2001 25' Safari")
  page.should have_content("Trailer is in good condition")
  page.should have_content('Length')
  page.should have_content('25')
  page.should have_content('Cortez, Colorado')
  page.should have_content('$40,000.00')
end
