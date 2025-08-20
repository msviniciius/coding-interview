FactoryBot.define do
  factory :tweet do
    association :user
    body { "hello world" }
  end
end
