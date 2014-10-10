class TeachersController < ApplicationController
  before_action :set_teacher, only: [:show, :edit, :update]
  before_action :require_user
  before_action :require_creator_or_admin, only: [:new, :create, :edit, :update]

  def index
    @teachers = Teacher.all.sort_by {|t| t.lastname}
  end

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(teacher_params)

    if @teacher.save
      flash[:notice] = "Teacher #{@teacher.first_last} was created"

      redirect_to teacher_path(@teacher)
    else
      render :new
    end
  end

  def edit
    # setting @teacher is handled by before_action to set the teacher instance var
  end

  def update
    if @teacher.update(teacher_params)
      flash[:notice] = "The Teacher \"#{@teacher.first_last}\" was updated."
      redirect_to teacher_path(@teacher)
    else
      render :edit
    end
  end

  def show
  end

  private

  def teacher_params
    params.require(:teacher).permit(:firstname, :lastname, schoolclass_ids: [])
  end

  def set_teacher
    begin
      @teacher = Teacher.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "There is no teacher with ID #{params[:id]}.  Showing all teachers instead."
      redirect_to teachers_path
    end
  end

  def require_creator_or_admin
    access_denied(teachers_path) unless allow_object_edit?(@teacher)
  end

end

