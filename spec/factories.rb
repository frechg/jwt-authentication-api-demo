FactoryBot.define do
  factory :user do
    username { "Person" }
    email  { "person@example.com" }
    password { "testingpass" }
    confirmation_token { nil }
  end
end
