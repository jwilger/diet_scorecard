require_dependency 'diet_scorecard/food_type'

class Food < ActiveRecord::Base
  belongs_to :meal
  serialize :servings, Hash

  validates :name, presence: true

  @@servings_fields = []

  DietScorecard::FoodType.each do |ft|
    field_name = "#{ft.key}_servings".to_sym
    @@servings_fields << field_name

    define_method(field_name) do
      servings_of(ft.key)
    end

    define_method("#{field_name}=") do |value|
      servings[ft.key] = value
    end

    validates field_name, numericality: true
  end

  def servings_of(food_type)
    servings.fetch(food_type, 0).to_f
  end

  def self.servings_fields
    @@servings_fields.dup
  end

  def servings_fields
    self.class.servings_fields
  end

  delegate :name, to: :meal, prefix: true
end
