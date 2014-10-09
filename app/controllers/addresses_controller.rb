class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update]
  before_action :set_addressable_for_address_creation, only: [:new, :create]
  before_action :require_creator_or_admin, only: [:new, :create, :edit, :update]
  
  def index
    @addresses = Address.all
  end

  def new
    @address = Address.new
    @address.addressable = @addressable
  end

  def create
    @address = Address.new(address_params)
    @address.addressable = @addressable

    ## TODO: set the user ID of the family
    ## @family.owner = current_user_get

    if @address.save
      case @address.addressable_type
      when "Parent"
        flash[:notice] = "Address for Parent #{@address.addressable.first_last} was created"
        redirect_to parent_path(@address.addressable)
      when "Family"
        flash[:notice] = "Address for Family #{@address.addressable.name} was created"
        redirect_to family_path(@address.addressable)
      end
    else
      render :new
    end
  end

  def edit
    # setting @address is handled by before_action to set the address instance var
  end

  def update
    if @address.update(address_params)

      ### TODO: DRY this up by moving to application_controller
      case @address.addressable_type
      when "Parent"
        flash[:notice] = "Address for Parent #{@address.addressable.first_last} was updated"
        redirect_to parent_path(@address.addressable)
      when "Family"
        flash[:notice] = "Address for Family #{@address.addressable.name} was updated"
        redirect_to family_path(@address.addressable)
      end
    else
      render :edit
    end
  end

  def show
  end

  private

  def address_params
    params.require(:address).permit(:address_line1, :address_line2, :city, :state, :zipcode)
  end

  def set_address
    begin
      @address = Address.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "There is no address with ID #{params[:id]}.  Showing all families instead."
      redirect_to families_path
    end
  end

  def set_addressable_for_address_creation
    # depending on what param is available we can determine
    # whether the addressable is a family or parent
    if (params[:family_id])
      begin      
        @addressable = Family.find(params[:family_id])
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = "There is no family with ID #{params[:family_id]}.  Cannot create an address for an invalid Family Record."

        ### figure out if this is the right place to redirect
        redirect_to families_path
      end
    elsif (params[:parent_id])
      begin      
        @addressable = Parent.find(params[:parent_id])
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = "There is no parent with ID #{params[:parent_id]}.  Cannot create an address for an invalid Parent Record."

        ### figure out if this is the right place to redirect
        redirect_to parents_path
      end
    else
      # we did not have a family or parent specified
      flash[:notice] = "Attempt to create address without providing a family or parent.  You must create an address record for a specific family or parent."

      ### figure out if this is the right place to redirect
      redirect_to families_path
    end
  end

  def require_creator_or_admin
    access_denied(families_path) unless allow_object_edit?(@address.addressable)
  end

end


