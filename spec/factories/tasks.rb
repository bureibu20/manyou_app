FactoryBot.define do
  factory :task do
    title { 'test_title1' }
    content { 'test_content' }
    expired_at {'2021-08-12'}
    status {'未着手'}
    priority {'高'}
    association :user
  end
  factory :second_task, class: Task do
    title { 'test_title2' }
    content { 'test_content' }
    expired_at {'2021-08-12 00:00:00'}
    status {'着手中'}
    priority {'中'}
    association :user
  end
end