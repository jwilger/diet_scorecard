require_relative 'food_type'
require_relative 'food_type_scorecard'

module DietScorecard
  class DailyScorecard
    attr_accessor :date
    private :date=

    def initialize(date:)
      self.date = date.to_date
    end

    def total_points
      food_type_scorecards.reduce(0) { |total, fts|
        total += fts.points_earned
      }
    end

    def food_type_scorecards
      FoodType.map { |ft| FoodTypeScoreCard.new(food_type: ft, date: date) }
    end

    def previous
      self.class.new(date: date - 1)
    end

    def next
      self.class.new(date: date + 1)
    end

    def to_param
      {:year => date.year.to_s, :month => date.month.to_s, :day => date.day.to_s}
    end
  end
end