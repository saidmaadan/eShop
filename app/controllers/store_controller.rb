class StoreController < ApplicationController
	
  def index
  	increment_counter
  	@products = Product.order(:title)
  end
end
