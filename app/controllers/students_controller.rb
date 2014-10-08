class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update]
  before_action :set_family_for_student_creation, only: [:new, :create]

  def index
    @students = Student.all.sort_by {|p| p.lastname}
  end

  def new
    @student = Student.new

    @student.family = @family
    # we expect that we get routed here only as a subordinate of family
    # so we set the family of the student
  end

  def create
    @student = Student.new(student_params)
    @student.family = @family  # @family is set in the before_action

    ## TODO: set the user ID of the family
    ## @family.owner = current_user_get

    if @student.save
      flash[:notice] = "Student #{@student.first_last} was created"
      redirect_to family_path(@family)
    else
      render :new
    end
  end

  def edit
    # setting @student is handled by before_action to set the student instance var
  end

  def update
    ### note what i tried to do but that I ended up not needing

    # http://stackoverflow.com/questions/8929230/why-is-the-first-element-always-blank-in-my-rails-multi-select-using-an-embedde
    # we want to delete the empty array entry
    #if (params[:student] && params[:student][:schoolclasses])
    #  params[:student][:schoolclasses].delete_if{|x| x.empty? }
    #  ##params[:student][:schoolclasses].map!{|x| Schoolclass.find_by(id: x.to_i)}
    #end

    if @student.update(student_params)
      flash[:notice] = "The Student \"#{@student.first_last}\" was updated."
      redirect_to student_path(@student)
    else
      render :edit
    end

  end

  def show
  end

  private

  def student_params
    params.require(:student).permit(:firstname, :lastname, :nickname, schoolclass_ids: [])
  end

  def set_student
    begin
      @student = Student.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "There is no student with ID #{params[:id]}.  Showing all families instead."
      redirect_to families_path
    end
  end

  def set_family_for_student_creation
    if (params[:family_id])
      begin      
        @family = Family.find(params[:family_id])
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = "There is no family with ID #{params[:family_id]}.  Cannot create a student for an invalid Family Record."

        ### figure out if this is the right place to redirect
        redirect_to families_path
      end

    else
      # we did not have a family be specified
      flash[:notice] = "Attempt to create student without providing a family identifier.  You must create a student record for a specific family."

      ### figure out if this is the right place to redirect
      redirect_to families_path
    end
  end
end

