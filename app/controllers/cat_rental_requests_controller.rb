class CatRentalRequestsController < ApplicationController
  before_action only: [:approve, :deny] do
    crr = CatRentalRequest.find(params[:cat_rental_request_id])
    user = current_user
    redirect_to cat_url(crr.cat_id) unless user && crr.cat_owner.id == user.id
  end
  
  def new
    @cats = Cat.all
    @crr = CatRentalRequest.new
    render :new
  end
  
  def create
    @crr = CatRentalRequest.new(crr_params)
    @crr.user_id = current_user.id
    
    if @crr.save
      redirect_to cat_url(@crr.cat_id)
    else
      flash.now[:errors] = @crr.errors.full_messages
      render :new
    end
  end
  
  def approve
    @crr = CatRentalRequest.find(params[:cat_rental_request_id])
    @crr.approve!
    redirect_to cats_url
  end
  
  def deny
    @crr = CatRentalRequest.find(params[:cat_rental_request_id])
    @crr.deny!
    redirect_to cats_url
  end
  
  def crr_params
    args = [:cat_id, :start_date, :end_date, :status]
    params.require(:cat_rental_request).permit(*args)
  end
    

    
  
end
