class IngredientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meal
  before_action :set_ingredient, only: %i[ show edit update destroy ]

  # GET /ingredients or /ingredients.json
  def index
    @pagy, @ingredients = pagy(@meal.ingredients.sort_by_params(params[:sort], sort_direction))
  end

  # GET /ingredients/1 or /ingredients/1.json
  def show
  end

  # GET /ingredients/new
  def new
    @ingredient = @meal.ingredients.new
  end

  # GET /ingredients/1/edit
  def edit
  end

  # POST /ingredients or /ingredients.json
  def create
    @ingredient = @meal.ingredients.new(ingredient_params)

    respond_to do |format|
      debugger
      if @ingredient.save
        format.html { redirect_to [@meal, @ingredient], notice: "Ingredient was successfully created." }
        format.json { render :show, status: :created, location: [@meal, @ingredient] }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream
            .prepend(:flash, partial: "shared/flash", locals: {alert: @ingredient.errors.full_messages.to_sentence})
        }
      end
    end
  end

  # PATCH/PUT /ingredients/1 or /ingredients/1.json
  def update
    respond_to do |format|
      if @ingredient.update(ingredient_params)
        format.html { redirect_to [@meal, @ingredient], notice: "Ingredient was successfully updated." }
        format.json { render :show, status: :ok, location: [@meal, @ingredient] }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream
            .prepend(:flash, partial: "shared/flash", locals: {alert: @ingredient.errors.full_messages.to_sentence})
        }
      end
    end
  end

  # DELETE /ingredients/1 or /ingredients/1.json
  def destroy
    @ingredient.destroy
    respond_to do |format|
      format.html { redirect_to meal_ingredients_url(@meal), status: :see_other, notice: "Ingredient was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream
    end
  end

  private
    def set_meal
      @meal = current_user.meals.find(params[:meal_id])
    
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_ingredient
      @ingredient = @meal.ingredients.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to meal_ingredients_path(@meal), alert: "Ingredient not found."
    end

    # Only allow a list of trusted parameters through.
    def ingredient_params
      params.require(:ingredient).permit(
        :grocery_id,
        :meal_id,
        :unit_type,
        :quantity,
        :notes,
        :purchased_at,
        grocery_attributes: [
          :name,
          :grocery_category_id,
          grocery_category_attributes: [
            :id,
            :name
          ]
        ]
      )
    end
end
