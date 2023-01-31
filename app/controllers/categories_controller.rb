class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ edit update destroy ]
  before_action :keep_hidden_category, only: %i[ edit update destroy ]

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit; end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to root_url, notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  def update
    if !params[:category][:move].nil?
      case params[:category][:move]
      when "left"
        @category.move_higher
      when "right"
        @category.move_lower
      when "top"
        @category.move_to_top
      when "bottom"
        @category.move_to_bottom
      end

      redirect_to root_url

    elsif @category.update(category_params)
      redirect_to root_url, notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  def destroy
    category_name = @category.name
    @category.destroy
    redirect_to root_url, notice: "Category #{category_name} was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  def keep_hidden_category
    return unless params[:category][:move].nil?

    redirect_to root_url, notice: "You cannot edit/delete the Hidden category" if @category.abbr == "Hidden"
  end

  # Only allow a list of trusted parameters through.
  def category_params
    params.require(:category).permit(:name, :abbr)
  end
end
