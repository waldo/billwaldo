source 'http://rubygems.org'

gem 'rails', '3.1.0.rc1'

gem 'sass'
gem 'coffee-script'
gem 'uglifier'
gem 'jquery-rails'
gem "json"

gem 'sprockets', '2.0.0.beta.8'
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

group :test do
  gem "fabrication"
end
