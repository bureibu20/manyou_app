FactoryBot.define do
  factory :label, class: Label do
    name { "test1" }
  end
  factory :second_label, class: Label do
    name { "test2" }
  end
end
