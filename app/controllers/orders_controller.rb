class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    cart = current_user.cart
    order = current_user.orders.build(total_price: calculate_total(cart), status: 'pending')

    cart.cart_items.each do |item|
      order.order_items.build(
        product: item.product,
        quantity: item.quantity,
        price: item.product.price
      )
    end

    if order.save
      cart.cart_items.destroy_all
      redirect_to orders_path, notice: '注文が確定しました'
    else
      redirect_to cart_path, alert: '注文に失敗しました'
    end
  end

  def index
    @orders = current_user.orders.includes(:order_items)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  private

  def calculate_total(cart)
    cart.cart_items.inject(0) do |sum, item|
      sum + item.product.price * item.quantity
    end
  end
end
