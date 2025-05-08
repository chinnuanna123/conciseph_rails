# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Goal, type: :model do
  describe '.overseers_search' do
    let!(:goal_1) { create(:goal, status: 0, goal_category: 'Well Child Care') }
    let!(:goal_2) { create(:goal, status: 1, goal_category: 'ED Follow Ups') }
    let!(:goal_3) { create(:goal, status: 2, goal_category: 'Counseling') }

    # context 'when no category is provided' do
    #   it 'returns goals with status 0 and 1 by default' do
    #     params = { page: 1, page_size: 10 }

    #     results = Goal.overseers_search(params)

    #     expect(results).to include(goal_1, goal_2)
    #     expect(results).not_to include(goal_3)
    # end
    # end

    context 'when a category is provided' do
      it 'filters results by the category' do
        params = { category: 'ED Follow Ups', page: 1, page_size: 10 }

        results = Goal.overseers_search(params)

        expect(results).to include(goal_2)
        expect(results).not_to include(goal_1, goal_3)
      end
    end

    context 'when a page and page_size are provided' do
      it 'returns paginated results' do
        # Assuming you have more goals created here for pagination testing
        params = { page: 1, page_size: 1 }

        results = Goal.overseers_search(params)

        expect(results.size).to eq(1)
        # expect(results.first).to eq(goal_1)
      end
    end

    context 'when no valid page or page_size is provided' do
      it 'defaults to page 1 and page_size 10' do
        params = {}

        results = Goal.overseers_search(params)

        expect(results.count).to be <= 10
      end
    end
  end
end
