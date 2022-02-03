# frozen_string_literal: true

namespace :openapi do
  desc 'generate the OpenAPI schemas of the ActiveRecord models'
  task models: :environment do
    puts 'generating model schemas'
    generator = Openapi::Models::Schemas.new
    # TODO: implement rest of the task
  end
end
