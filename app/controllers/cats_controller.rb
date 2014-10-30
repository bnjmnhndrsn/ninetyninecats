class CatsController < ApplicationController
  before_action only: [:edit, :update] do
    cat, user = Cat.find(params[:id]), current_user
    redirect_to cat_url(cat.id) unless user && cat.user_id == user.id
  end
  
  
  
  def index
    @cats = Cat.all
    render :index
  end
  
  def show
    @cat = Cat.find(params[:id])
    @crr = CatRentalRequest.where(cat_id: @cat.id)
    @crr = @crr.order(:start_date)
    render :show
  end
  
  def new
    @cat = Cat.new
    # @colors = ['black', 'white', 'brown', 'calico', 'orange']
    render :new
  end
  
  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    @cats = Cat.all
    if @cat.save
      render :index
    else
      #talk about me next
      self.flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end
  
  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end
  
  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end
  
  def cat_params
    cat_attrs = [:birth_date, :color, :name, :sex, :description]
    params.require(:cat).permit(*cat_attrs)
  end
end
