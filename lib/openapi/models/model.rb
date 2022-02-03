# frozen_string_literal: true

module OpenApi
  module Models
    # renders an ActiveRecord::Base model as OpenAPI schema.
    class Model
      attr_reader :model, :base_colum_schemas

      # @param model [ActiveRecord::Base] the model to parse
      # @param only [Array<Symbol|String>] optionally parse only these columns
      # @param except [Array<Symbol|String>] optionally parse all columns except these
      # @param optional [Array<Symbol|String>] make columns optional in schema
      # @param optional [Array<Symbol|String>] integrate attribute like methods in schema
      def initialize(model:, only: [], except: [], optional: [], methods: [])
        @model = model
        @optional = optional
        @methods = methods
        @base_column_schemas = Parse.new(
          model: model, only: only, except: except,
          methods: methods, optional: optional
        )
      end
      delegate :model_name, to: :model
      delegate :name, to: :model_name
      delegate :i18n_key, to: :model_name
      alias key i18n_key

      def to_h
        {
          type: 'object',
          description: "Generated schema for #{name} model.",
          properties: base_column_schemas.properties,
          required: [], # TODO: implement required parseing
          example: {}   # TODO: implement example generator
        }.deep_stringify_keys
      end
      alias to_hash to_h
      delegate :to_json, to: :to_h
      delegate :to_yaml, to: :to_h
      alias to_yml to_yaml
    end
  end
end
