class ProductsController < ApplicationController

  def index
    logger.debug(Product.active.where(:size => 25).all.map(&:price_last))
  end

  def show
    @product = Product.find(params[:id])
  end

  def length
    @products_active = Product.active.where(:size => params[:length]).order(product_order)
    @products_inactive = Product.inactive.where(:size => params[:length]).order(product_order)
  end


  private 

  def product_order
    %W(days_active year price size).include?(params[:order]) ? params[:order] : 'id'
  end

end
