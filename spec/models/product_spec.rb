require 'spec_helper'

describe Product do


end

describe "Product Sync" do 

  before(:each) do
    showcat_response = File.new(Rails.root + "spec/webmock_stubs/showcat_16.txt")
    stub_request(:get, "http://www.airstreamclassifieds.com/showcat.php?cat=16&perpage=90").to_return(showcat_response.read)  
  end


  it "returns proper number of ids from external site" do
    Product.active_external_ids.size.should == 63
  end

  it "returns only ids which are 5 digit numbers" do
    Product.active_external_ids.each do |e_id|
      e_id.to_i.should >= 10000
      e_id.to_i.should <= 99999
    end
  end

  it "gets marked as removed" do
    Fabricate(:product, external_id: 10000)
    Product.active.count.should == 1
    Product.mark_removed
    Product.active.count.should == 0
    Product.find_by_external_id(10000).removed_at.should_not be_nil
  end


  it "after syncing there should be a database entry for each" do
    Product.active_external_ids.each do |eid|
      showcat_response = File.new(Rails.root + "spec/webmock_stubs/show_product_#{eid}.txt")
      stub_request(:get, "http://www.airstreamclassifieds.com/showproduct.php?product=#{eid}").to_return(showcat_response.read)  
    end

    Product.sync_active_external_ids
    Product.count.should == 63
  end

end



describe "Product sync a single normal active external id" do
  before(:each) do
    showcat_response = File.new(Rails.root + "spec/webmock_stubs/show_product_19003.txt")
    stub_request(:get, "http://www.airstreamclassifieds.com/showproduct.php?product=19003").to_return(showcat_response.read)  

    @product = Fabricate(:product, external_id: 19003)
    @product.sync_details
  end

  it "should have a title" do
    @product.title.should == "1988 Excella 25 foot."
  end

  it "should have a listed date" do
    @product.listed_at.should == Time.parse("09-05-2013 12:00:00")
  end

  it "should have a normalized asking price" do
    @product.price_last.should == 10500
  end

  it "should be in good condition" do
    @product.condition.should == 'Good'
  end

  it "should describe the product" do 
    @product.description.should include('1988 Excella with 2-50 watt solar panels')
  end

  it "should have a year built" do
    @product.year.should == 1988
  end

  it "should have a model name" do
    @product.make_model.should == 'Airstream Excella'
  end

  it "should have a length/size" do
    @product.size.should == 25
  end

  it "should be located in Missouri" do 
    @product.location.should == 'Missouri'
  end

  it "should have days active" do
    @product.days_active.should == ((Time.now - @product.listed_at) / 86400).to_i
  end

  it "should be not sold" do
    @product.sold.should be false
  end

end



describe "sync a trailer with missing attributes" do
  before(:all) do
    showcat_response = File.new(Rails.root + "spec/webmock_stubs/show_product_18892.txt")
    stub_request(:get, "http://www.airstreamclassifieds.com/showproduct.php?product=18892").to_return(showcat_response.read)  

    @product = Fabricate(:product, external_id: 18892)
    @product.sync_details
  end

  it "should have a title" do
    @product.title.should == "25' Airstream Safari Special Edition"
  end

  it "should have a listed date" do
    @product.listed_at.should == Time.parse("27-04-2013 12:00:00")
  end

  it "should have a normalized asking price" do
    @product.price_last.should be_nil
  end

  it "should be in good condition" do
    @product.condition.should == 'Excellent'
  end

  it "should describe the product" do 
    @product.description.should include('2006')
  end

  it "should have a year built" do
    @product.year.should be_nil
  end

  it "should not have a model name" do
    @product.make_model.should == ''
  end

  it "should have a length/size" do
    @product.size.should be_nil
  end

  it "should no be located in Missouri" do 
    @product.location.should == ''
  end

  it "should be not sold" do
    @product.sold.should be false
  end

end


describe "sync a sold trailer with a changed price" do
  before(:all) do
    showcat_response = File.new(Rails.root + "spec/webmock_stubs/show_product_18802.txt")
    stub_request(:get, "http://www.airstreamclassifieds.com/showproduct.php?product=18802").to_return(showcat_response.read)  

    @product = Fabricate(:product, external_id: 18802, price: 50000)
    @product.sync_details
  end

  it "should be sold" do
    @product.sold.should be true
  end

  it "should have a new asking price" do
    @product.price_last.should == 38995
  end

  it "should have a saved older asking price" do
    @product.price.should == 50000
  end



end


