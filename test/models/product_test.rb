require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "product attributes must not be empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
  	assert product.errors[:price].any?
  	assert product.errors[:image_url].any?
  end

  test 'product price must be positive' do
  	product = Product.new(title: "Ruby Motion", description: "New version of ruby motion",
  	                       image_url: 'ghost.jpeg')
  	product.price = -1
  	assert product.invalid?
  	assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

  	product.price = 0
  	assert product.invalid?
  	assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

  	product.price = 1
  	assert product.valid?
  end

  def new_product(image_url)
  	Product.new(title: "Product title",
  		          description: "Product description", price: 1, image_url: image_url)
  end

  test "image_url" do
  	ok = %w{ fred.gif fred.jpg fred.png fred.jpeg FRED.JPG FRED.jpg
  	         http://a.b.c/x/y/z/fred.gif }
  	bad = %w{ fred.doc fred.gif/more fred.gif.more }
  	ok.each do |name|
  		assert new_product(name).valid?, "#{name} should be valid"
  	end
  	bad.each do |name|
  		assert new_product(name).invalid?, "#{name} should't be valid"
  	end
  end

  test "product is not valid without a unique title" do
  	product = Product.new(title: products(:ruby).title, description: "product title", price: 1, image_url: "ghost.jpeg")
  	assert product.invalid?
  	assert_equal ["has already been taken"], product.errors[:title]
  end

  test "product is not valid without a unique title - i18n" do
  	product = Product.new(title: products(:ruby).title, description: "product title", price: 1, image_url: "ghost.jpeg")
  	assert product.invalid?
  	assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
end
