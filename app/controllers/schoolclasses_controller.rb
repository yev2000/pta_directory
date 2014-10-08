class SchoolclassesController < ApplicationController
  before_action :set_schoolclass, only: [:show, :edit, :update]

  def index
    @schoolclasses = Schoolclass.all.sort_by {|sc| sc.name}
  end

  def new
    @schoolclass = Schoolclass.new
  end

  def create
    @schoolclass = Schoolclass.new(schoolclass_params)

    if @schoolclass.save
      flash[:notice] = "Class #{@schoolclass.name} was created"

      ### TODO: figure out where to redirect.  Some admin screen?
      redirect_to schoolclasses_path
    else
      render :new
    end
  end

  def edit
    # setting @schoolclass is handled by before_action to set the schoolclass instance var
  end

  def update
    if @schoolclass.update(schoolclass_params)
      flash[:notice] = "The Class \"#{@schoolclass.name}\" was updated."
      redirect_to schoolclass_path(@schoolclass)
    else
      render :edit
    end
  end

  def show
  end


  def add_teacher
    # we need to set up state so that we can provide
    # a picklist of teachers, and those teachers
    # can be assigned to the class identified in the params
  end

  def add_student
    # we need to set up state so that we can provide
    # a picklist of students, and those students
    # can be assigned to the class identified in the params
  end

  def set_teachers
  end

  def set_students
  end
  
  private

  def schoolclass_params
    params.require(:schoolclass).permit(:name)
  end

  def set_schoolclass
    begin
      @schoolclass = Schoolclass.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "There is no Class with ID #{params[:id]}.  Showing all classes instead."
      redirect_to schoolclasses_path
    end
  end

end
