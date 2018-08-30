require "bundler/setup"
require "bca_statement"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    BcaStatement.configure do |config|
      config.client_id = ENV['client_id']
      config.client_secret = ENV['client_secret']
      config.corporate_id = ENV['corporate_id']
      config.account_number = ENV['account_number']
      config.api_key = ENV['api_key']
      config.api_secret = ENV['api_secret']
      config.base_url = ENV['base_url']
      config.domain = ENV['domain']
    end
  end
end
