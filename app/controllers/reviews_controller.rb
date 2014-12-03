class ReviewsController < ApplicationController
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :set_restaurant
  before_action :authenticate_user!
  before_action :check_user, only: [:edit, :update, :destroy]
  
  def new
    @review = Review.new
  end
  
  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.restaurant_id = @restaurant.id
    if @review.save
      redirect_to @restaurant, notice: 'Review was successfully created.'
    else
      render :new
    end
  end
  
  def update
    if @review.update(review_params)
      redirect_to @review, notice: 'Review was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @review.destroy
    redirect_to restaurant_path(@restaurant), notice: 'Review was successfully destroyed.'
  end
  
  private

    def set_review
      @review = Review.find(params[:id])
    end

    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def check_user
      unless (@review.user == current_user) || (current_user.admin?)
        redirect_to root_url, alert: "Sorry, this review belongs to someone else."
      end
    end

    def review_params
      params.require(:review).permit(:rating, :comment)
    end
end
  