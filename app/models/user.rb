class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         has_many :meals, dependent: :destroy
  has_many :favorite_meal_templates
  has_many :commands, dependent: :destroy
  def favorite_meal_template(id) 
    favorite_meal_templates.find_by(meal_template: id) 
  end
end
