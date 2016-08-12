FactoryGirl.define do
  factory :paper do
    sequence(:title) { |n| "Sample Paper #{n}" }
    abstract "Sample abstract with long content"
    outline "Sample outline with long content"
    speaker_bio "Speaker bio with long content"
    language "Chinese"
    user { FactoryGirl.create(:user) }
    activity { FactoryGirl.create(:activity) }

    factory :paper_with_review do
      transient do
        review_by { FactoryGirl.create(:user) }
      end

      after(:create) do |paper, evaluator|
        create(:review, paper: paper, user: evaluator.review_by)
      end
    end

  end
end
