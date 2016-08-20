# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :news_release do
    title "Fake News Release"
    released_on "2013-07-29"
    body { Faker::Lorem.paragraph }

    factory :invalid_news_release do
      body ""
    end
  end
end
