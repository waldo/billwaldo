source 'http://rubygems.org'

gem 'rails', '3.1.0.beta1'

gem 'sass'
gem 'coffee-script'
gem 'uglifier'
gem 'jquery-rails'
gem "json"

# sprockets beta 2 and latest mongoid play happily
gem 'sprockets', '2.0.0.beta.2'
gem "mongoid", :git => "https://github.com/mongoid/mongoid.git"
gem "bson_ext", "~> 1.3"
gem "uuidtools"

# to allow heroku to use rails 3.1
group :production do
  gem "therubyracer-heroku", "0.8.1.pre3"
end

group :development do
  gem "therubyracer", :require => "v8"
end
