# frozen_string_literal: true

module OpenApi
  module Models
    # renders an ActiveRecord::Base model as OpenAPI schema.
    class Model
      attr_reader :model, :base_colum_schemas, :properties

      # @param model [ActiveRecord::Base] the model to parse
      # @param only [Array<Symbol|String>] optionally parse only these columns
      # @param except [Array<Symbol|String>] optionally parse all columns except these
      # @param optional [Array<Symbol|String>] make columns optional in schema
      # @param optional [Array<Symbol|String>] integrate attribute like methods in schema
      def initialize(model:, only: [], except: [], optional: [], methods: [])
        @model = model
        @optional = optional
        @methods = methods
        @base_column_schemas = BaseColumnSchemas.new(model, only: only, except: except, methods: methods)
        @properties = base_column_schemas.properties
      end
    end
  end
end
