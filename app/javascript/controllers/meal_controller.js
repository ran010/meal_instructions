import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

// Connects to data-controller="meals"
export default class extends Controller {
  static targets = ["form"]
  connect() {
  }
  
  clear() {
    this.element.reset()
  }
  searchMealTemplates(e){
    var meal_templates_list = document.getElementById("meal_templates")
    var meal_templates_results = document.getElementById("meal_templates_results")

    if (e.target.value.length > 0) {
      meal_templates_list.classList.add("hidden")
      meal_templates_results.classList.remove("hidden")
    } else {
      meal_templates_list.classList.remove("hidden")
      meal_templates_results.classList.add("hidden")
    }
  }
}
