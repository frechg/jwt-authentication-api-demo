FactoryBot.define do
  factory :user do
    username { "Person" }
    email  { "person@exampl.com" }
    password { "testingpass" }
  end
end
