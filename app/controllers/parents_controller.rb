class ParentsController < ApplicationController
  before_action :set_parent, only: [:show, :edit, :update]
  before_action :set_family_for_parent_creation, only: [:new, :create]
  before_action :require_user
  before_action :require_creator_or_admin, only: [:new, :create, :edit, :update]

  def index
    @parents = Parent.all.sort_by {|p| p.lastname}
  end

  def new
    @parent = Parent.new

    @parent.family = @family
    # we expect that we get routed here only as a subordinate of family
    # so we set the family of the parent
  end

  def create
    @parent = Parent.new(parent_params)
    @parent.family = @family  # @family is set in the before_action

    ## TODO: set the user ID of the family
    ## @family.owner = current_user_get

    if @parent.save
      flash[:notice] = "Parent #{@parent.first_last} was created"
      redirect_to parent_path(@parent)
    else
      render :new
    end
  end

  def edit
    # setting @parent is handled by before_action to set the parent instance var
  end

  def update
    if @parent.update(parent_params)
      flash[:notice] = "The parent \"#{@parent.first_last}\" was updated."
      redirect_to parent_path(@parent)
    else
      render :edit
    end
  end

  def show
  end

  private

  def parent_params
    params.require(:parent).permit(:firstname, :lastname)
  end

  def set_parent
    begin
      @parent = Parent.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "There is no parent with ID #{params[:id]}.  Showing all parents instead."
      redirect_to parents_path
    end
  end

  def set_family_for_parent_creation
    if (params[:family_id])
      begin      
        @family = Family.find(params[:family_id])
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = "There is no family with ID #{params[:family_id]}.  Cannot create a parent for an invalid Family Record."

        ### figure out if this is the right place to redirect
        redirect_to families_path
      end

    else
      # we did not have a family be specified
      flash[:notice] = "Attempt to create parent without providing a family identifier.  You must create a parent record for a specific family."

      ### figure out if this is the right place to redirect
      redirect_to families_path
    end
  end

  def require_creator_or_admin
    case
    when @parent.nil? && @family.nil?
      access_denied(parents_path)
    when @parent.nil?
      access_denied(parents_path) unless allow_object_edit?(@family)
    else
      access_denied(parents_path) unless allow_object_edit?(@parent)
    end
  end

end
