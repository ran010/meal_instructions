class MealsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meal, only: %i[ show edit update destroy ]

  # GET /meals or /meals.json
  def index
    @pagy, @meals = pagy(current_user.meals.sort_by_params(params[:sort], sort_direction))
  end

  # GET /meals/1 or /meals/1.json
  def show
    @ingredients = @meal.ingredients.includes([grocery: :grocery_category])
    @instructions = @meal.instruction_steps
  end

  def load_templates
    @meal_templates = MealTemplate.all
  end

  def create_from_template
    @meal = Meals::CreateFromTemplateWorkflow.call(meal_template_id: params[:meal_template_id], user: current_user)
    respond_to do |format|
      if @meal.errors.blank?
        format.html { redirect_to @meal, notice: "Meal was successfully created." }
        format.json { render :show, status: :created, location: @meal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /meals/new
  def new
    @meal = current_user.meals.new
  end

  # GET /meals/1/edit
  def edit
  end

  # POST /meals or /meals.json
  def create
    @meal = if meal_params[:meal_template_id].present?
      Meals::CreateFromTemplateWorkflow.call(meal_template_id: meal_params[:meal_template_id], user: user)
    else
      Meals::CreateWorkflow.call(meal_params.merge!(user: current_user))
    end

    respond_to do |format|
      if @meal.errors.blank?
        format.html { redirect_to @meal, notice: "Meal was successfully created." }
        format.json { render :show, status: :created, location: @meal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /meals/1 or /meals/1.json
  def update
    respond_to do |format|
      if @meal.update(meal_params)
        format.html { redirect_to @meal, notice: "Meal was successfully updated." }
        format.json { render :show, status: :ok, location: @meal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meals/1 or /meals/1.json
  def destroy
    @meal.destroy

    respond_to do |format|
      format.html { redirect_to meals_url, notice: "Meal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meal
      @meal = current_user.meals.find(params[:id])

    rescue ActiveRecord::RecordNotFound
      redirect_to meals_path
    end

    # Only allow a list of trusted parameters through.
    def meal_params
      params.require(:meal).permit(
        :name,
        :description,
        :bookmark,
        :prep_time,
        :cook_time,
        :total_time,
        :serving_for,
        :ingredients_count,
        :completed_at,
        :meal_template_id
      )
    end
end
