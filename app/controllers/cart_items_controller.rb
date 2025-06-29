class CartItemsController < ApplicationController
  before_action :authenticate_user!
  def create
    puts current_user.inspect
    @cart = current_user.cart
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_by(product_id: product.id)

    if cart_item
      cart_item.quantity += 1
    else
      cart_item = @cart.cart_items.new(product: product, quantity: 1)
    end

    if cart_item.save
      redirect_to  cart_path, notice: '商品をカートに追加しました。'
    else
      redirect_to products_path, alert: 'カートへの追加に失敗しました'
    end
  end

  def update
    @cart = current_user.cart
    cart_item = @cart.cart_items.find(params[:id])

    if cart_item.update(quantity: params[:quantity])
      redirect_to cart_path, notice: '数量を更新しました'
    else
      redirect_to cart_path, arert: '数量の更新に失敗しました'
    end
  end

  def destroy
    @cart = current_user.cart
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: '商品をカートから削除しました'
  end
end
