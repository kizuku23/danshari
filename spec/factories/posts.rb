FactoryBot.define do
  factory :post do
    description { Faker::Lorem.characters(number:100) }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixture/no-image.jpg')) }
    user
    category
  end
end
