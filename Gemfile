# frozen_string_literal: true

ruby File.read('.ruby-version').strip

source 'https://rubygems.org'

gemspec

gem 'rails', '>= 6.1.0'

group :code_quality do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'bundler-leak', require: false
  gem 'dead_end'
  gem 'fasterer', require: false # hints for slow code
  gem 'reek'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'simplecov'
end

group :development do
  gem 'rake'
end

group :test do
  gem 'guard-rspec', require: false
  gem 'rspec'
end

group :tools do
  gem 'amazing_print'
  gem 'debride', require: false
  gem 'debug'
  gem 'fastri', require: false
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'rb-readline', require: false
  gem 'rcodetools', require: false # rcodetools is a collection of Ruby code manipulation tools.
  gem 'ruby-debug-ide', require: false # An interface which glues ruby-debug to IDEs like RubyMine.
  gem 'rufo', require: false # Fast and unobtrusive Ruby code formatter
  gem 'solargraph'
  gem 'yard'
end
