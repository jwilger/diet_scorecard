require 'diet_scorecard/meal_scorecard'

describe DietScorecard::MealScorecard do
  describe '.for_date' do
    subject { described_class.for_date(the_date, meals_service: meals_service) }
    let(:the_date) { Date.today }
    let(:meals_service) { double(:meals_service) }

    it 'builds a meal scorecard for each meal recorded on the specified date' do
      expect(meals_service).to receive(:for_date).with(the_date) \
        .and_return([:meal_a, :meal_b])
      expect(described_class).to receive(:new).with(meal: :meal_a) \
        .and_return(:meal_sc_a)
      expect(described_class).to receive(:new).with(meal: :meal_b) \
        .and_return(:meal_sc_b)
      expect(subject).to eq [:meal_sc_a, :meal_sc_b]
    end
  end

  subject { described_class.new(meal: meal) }

  let(:food_a) { double(:food_a, servings_of: 0) }
  let(:food_b) { double(:food_b, servings_of: 0) }
  let(:food_c) { double(:food_c, servingd_of: 0) }

  let(:meal) { double(:meal, foods: [food_a, food_b, food_c]) }

  it 'sums up the servings in the meal of the given food type' do
    expect(food_a).to receive(:servings_of).with(:dairy).and_return(1)
    expect(food_b).to receive(:servings_of).with(:dairy).and_return(0)
    expect(food_c).to receive(:servings_of).with(:dairy).and_return(1)
    expect(subject.total_servings(:dairy)).to eq 2
  end
end
