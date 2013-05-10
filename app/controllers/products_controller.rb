class ProductsController < ApplicationController

  def index

  end

  def show
    @product = Product.find(params[:id])
  end

  def length
    params[:length] = nil if params[:length] == 'undef'
    @products_active = Product.active.where(:size => params[:length]).order(product_order)
    @products_inactive = Product.inactive.where(:size => params[:length]).order(product_order)
  end


  private 

  def product_order
    %W(days_active year price size).include?(params[:order]) ? params[:order] : 'id'
  end

end
