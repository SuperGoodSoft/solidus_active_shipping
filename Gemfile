source "https://rubygems.org"

branch = ENV.fetch('SOLIDUS_BRANCH', 'main')
gem "solidus", github: "solidusio/solidus", branch: branch

gem "rails-controller-testing", group: :test

if branch < 'v2.5'
  gem 'factory_bot', '4.10.0'
else
  gem 'factory_bot', '> 4.10.0'
end

gem 'sqlite3'
gem 'pg'
gem 'mysql2'

gem "active_shipping", github: "SuperGoodSoft/active_shipping", branch: "thrill-jockey"

gemspec
