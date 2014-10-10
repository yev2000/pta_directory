class FamiliesController < ApplicationController
  before_action :set_family, only: [:show, :edit, :update]
  before_action :require_user
  before_action :require_creator_or_admin, only: [:edit, :update]

  def index
    @families = Family.all
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    
    # the user who creates the family is the one who is allowed to later edit it
    @family.family_administrator = current_user_get

    if @family.save
      flash[:notice] = "Family #{@family.name} was created"
      redirect_to family_path(@family)
    else
      render :new
    end
  end

  def edit
    # setting @family is handled by before_action to set the family instance var
  end

  def update
    if @family.update(family_params)
      flash[:notice] = "The family \"#{@family.name}\" was updated."
      redirect_to family_path(@family)
    else
      render :edit
    end
  end

  def show
  end

  private

  def family_params
    params.require(:family).permit(:name)
  end

  def set_family
    begin
      @family = Family.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "There is no family with ID #{params[:id]}.  Showing all families instead."
      redirect_to families_path
    end
  end

  def require_creator_or_admin
    access_denied(family_path(@family)) unless allow_object_edit?(@family)
  end

end
