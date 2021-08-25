FactoryBot.define do
  factory :admin_user, class: User do
    name {'admin_name'}
    email {'admin_email@gmail.com'}
    password {'admin_pass'}
    password_confirmation {'admin_pass'}
    admin {true}
  end

  factory :general_user, class: User do
    name {'general_name'}
    email {'general_email@gmail.com'}
    password {'general_pass'}
    password_confirmation {'general_pass'}
    admin {false}
  end
end
