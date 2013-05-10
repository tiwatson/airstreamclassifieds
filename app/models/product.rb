class Product < ActiveRecord::Base
  attr_accessible :created_at, :days_active, :description, :id, :listed_at, :location, :make_model, :price, :price_last, :external_id, :removed_at, :size, :sold, :title, :updated_at, :url, :year

  scope :active, where('removed_at IS NULL AND sold = false')
  scope :inactive, where('removed_at IS NOT NULL OR sold = true')

  def is_active?
    self.removed_at.nil? && !self.sold?
  end

  def url
    "http://www.airstreamclassifieds.com/showproduct.php?product=#{self.external_id}"
  end

  def sync_details

    doc = Nokogiri::HTML(open("http://www.airstreamclassifieds.com/showproduct.php?product=#{self.external_id}"))

    self.title        = doc.xpath(ProductXpaths[:title]).text
    self.condition    = doc.xpath(ProductXpaths[:condition]).text
    self.description  = doc.xpath(ProductXpaths[:description]).text.strip!
    self.year         = doc.xpath(ProductXpaths[:year]).text.strip!
    self.make_model   = doc.xpath(ProductXpaths[:make_model]).text.strip! || ''
    self.size         = doc.xpath(ProductXpaths[:size]).text.strip!
    self.location     = doc.xpath(ProductXpaths[:location]).text.strip! || ''

    listed_at_tmp = doc.xpath(ProductXpaths[:listed_at]).text.split('/')
    self.listed_at = Time.parse("#{listed_at_tmp[2]}-#{listed_at_tmp[0]}-#{listed_at_tmp[1]} 12:00:00")

    asking_tmp = doc.xpath(ProductXpaths[:price]).text

    if asking_tmp.downcase.include?('sold')
      self.sold = true
    end    

    if asking_tmp.include?('.00')
      asking_tmp.gsub!('SOLD!','')
      asking_tmp.gsub!('(','')
      asking_tmp.gsub!(')','')
      asking_tmp.gsub!('$','').gsub!(',','').gsub!('.00','').strip!
      self.price ||= asking_tmp
      self.price_last = asking_tmp
    end

    unless self.sold && self.removed_at.nil?
      self.days_active = (Time.now - self.listed_at) / 86400
    end

    self.sold ||= false
    self.save

  end


  def self.sync_active_external_ids
    Product.active_external_ids.each do |external_id|
      product = Product.find_or_create_by_external_id(external_id)
      product.sync_details
    end
  end

  def self.mark_removed
    products = Product.arel_table
    Product.active.where(products[:external_id].not_in(Product.active_external_ids)).each do |product|
      product.update_attribute(:removed_at, Time.now)
    end
  end

  def self.active_external_ids
    return @active_external_ids unless @active_external_ids.nil?
    doc = Nokogiri::HTML(open('http://www.airstreamclassifieds.com/showcat.php?cat=16&perpage=90'))
    @active_external_ids = (doc/"span.medium/a").collect { |h| h.attributes['href'].value[/product=(\d*)/,1] }.compact
    return @active_external_ids
  end


  def self.import
    json = JSON.parse(File.new(Rails.root + 'tmp/dump.txt').read)
    json.each do |i|
      i["external_id"] = i["product"]
      i.delete('product')
      i.delete('url')
      p = Product.new(i)
      p.id = i["id"]
      p.save
    end
    return ''
  end


end
