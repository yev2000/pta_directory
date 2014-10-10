class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update]
  before_action :set_contactable_for_contact_creation, only: [:new, :create]
  before_action :require_user
  before_action :require_creator_or_admin, only: [:new, :create, :edit, :update]

  def index
    @contacts = Contact.all
  end

  def new
    @contact = Contact.new
    @contact.contactable = @contactable
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.contactable = @contactable

    ## TODO: set the user ID of the family
    ## @family.owner = current_user_get

    if @contact.save
      case @contact.contactable_type
      when "Parent"
        flash[:notice] = "Contact for Parent #{@contact.contactable.first_last} was created"
        redirect_to parent_path(@contact.contactable)
      when "Family"
        flash[:notice] = "Contact for Family #{@contact.contactable.name} was created"
        redirect_to family_path(@contact.contactable)
      end
    else
      render :new
    end
  end

  def edit
    # setting @contact is handled by before_action to set the contact instance var
  end

  def update
    if @contact.update(contact_params)

      ### TODO: DRY this up by moving to application_controller
      case @contact.contactable_type
      when "Parent"
        flash[:notice] = "Contact for Parent #{@contact.contactable.first_last} was updated"
        redirect_to parent_path(@contact.contactable)
      when "Family"
        flash[:notice] = "Contact for Family #{@contact.contactable.name} was updated"
        redirect_to family_path(@contact.contactable)
      end
    else
      render :edit
    end
  end

  def show
  end

  private

  def contact_params
    params.require(:contact).permit(:contact_type, :contact_data)
  end

  def set_contact
    begin
      @contact = Contact.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "There is no contact with ID #{params[:id]}.  Showing all families instead."
      redirect_to families_path
    end
  end

  def set_contactable_for_contact_creation
    # depending on what param is available we can determine
    # whether the contactable is a family or parent
    if (params[:family_id])
      begin      
        @contactable = Family.find(params[:family_id])
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = "There is no family with ID #{params[:family_id]}.  Cannot create a contact for an invalid Family Record."

        ### figure out if this is the right place to redirect
        redirect_to families_path
      end
    elsif (params[:parent_id])
      begin      
        @contactable = Parent.find(params[:parent_id])
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = "There is no parent with ID #{params[:parent_id]}.  Cannot create a contact for an invalid Parent Record."

        ### figure out if this is the right place to redirect
        redirect_to parents_path
      end
    else
      # we did not have a family or parent specified
      flash[:notice] = "Attempt to create contact without providing a family or parent.  You must create a contact record for a specific family or parent."

      ### figure out if this is the right place to redirect
      redirect_to families_path
    end
  end

  def require_creator_or_admin
    access_denied(families_path) unless allow_object_edit?(@contact.contactable)
  end
end


