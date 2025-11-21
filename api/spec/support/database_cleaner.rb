require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
  
  config.after do
    `rm -rf spec/tmp`
  end
  
  config.before(:suite) do
    Rails.application.load_seed # ensure seeds are loaded before runs tests suite
  end
end