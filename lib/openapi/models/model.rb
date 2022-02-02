# frozen_string_literal: true

module OpenApi
  module Models
    # renders an ActiveRecord::Base model as OpenAPI schema.
    class Model
      attr_reader :model, :base_colum_schemas

      # @param model [ActiveRecord::Base] the model to parse
      # @param only [Array<Symbol|String>] optionally parse only these columns
      # @param except [Array<Symbol|String>] optionally parse all columns except these
      def initialize(model, only: [], except: [])
        @model = model
        @base_column_schemas = BaseColumnSchemas.new(model, only: only, except: except)
      end
      delegate :columns, to: :base_colum_schemas
    end
  end
end
