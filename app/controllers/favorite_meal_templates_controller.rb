class FavoriteMealTemplatesController < ApplicationController
  before_action :set_meal_template

  def create
    @favorite_meal_template = current_user.favorite_meal_templates.new(meal_template: @meal_template)

    respond_to do |format|
      if @favorite_meal_template.save
        format.html { redirect_to meal_template_path(@meal_template), notice: "Meal template added to favorites" }
        format.json { render :show, status: :created, location: @meal_template }
        
        format.turbo_stream do
          render turbo_stream: [
              turbo_stream.replace(helpers.dom_id(@meal_template, :favorite_meal_template), FavoriteMealTemplateComponent.new(meal_template: @meal_template, current_user: current_user).render_in(view_context))
          ]
         end
      else
        format.html { redirect_to meal_template_path(@meal_template), alert: "Meal template is already added to your favorites" }
        format.json { render json: @meal_template.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @favorite_meal_template = current_user.favorite_meal_templates.find_by(meal_template: @meal_template)

    respond_to do |format|
      if @favorite_meal_template.destroy
        format.html { redirect_to meal_template_path(@meal_template), notice: "Meal template removed to favorites" }
        format.json { render :show, status: :created, location: @meal_template }
       
        format.turbo_stream do
          render turbo_stream: [
              turbo_stream.replace(helpers.dom_id(@meal_template, :favorite_meal_template), FavoriteMealTemplateComponent.new(meal_template: @meal_template, current_user: current_user).render_in(view_context))
          ]
         end
      else
        format.html { redirect_to meal_template_path(@meal_template), alert: "Meal template is already removed to your favorites" }
        format.json { render json: @meal_template.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_meal_template
    @meal_template = MealTemplate.find(params[:meal_template_id])
  end
end
