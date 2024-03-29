class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[ edit update destroy ]
  before_action :set_categories

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit; end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to root_url, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if !params[:project][:move].nil?
      case params[:project][:move]
      when "left"
        @project.move_higher
      when "right"
        @project.move_lower
      when "top"
        @project.move_to_top
      when "bottom"
        @project.move_to_bottom
      end
      redirect_to root_url
    elsif @project.update(project_params)
      redirect_to root_url, notice: "Project was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy
    redirect_to root_url, notice: "Project was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  def set_categories
    @categories = Category.all
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:title, :description, :code_url, :live_url, :image, :category_id, :featured)
  end
end
