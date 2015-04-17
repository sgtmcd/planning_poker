# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
PlanningPoker::Application.initialize!
config.gem 'redis'
ENV["REDISTOGO_URL"] =  'redis://redistogo:1584cd3be2bf39a6e9310cd5de5e5be8@grouper.redistogo.com:10625/'