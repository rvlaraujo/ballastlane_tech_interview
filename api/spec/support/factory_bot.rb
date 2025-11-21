RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  FactoryBot::Syntax::Methods.include(Helpers::GenerateIsbn)
end