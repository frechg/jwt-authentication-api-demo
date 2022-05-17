FactoryBot.define do
  factory :user do
    user_name { "Person" }
    email  { "person@exampl.com" }
    password { "testingpass" }
  end
end
