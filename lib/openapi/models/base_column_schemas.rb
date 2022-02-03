# frozen_string_literal: true

module OpenApi
  module Models
    # Parse main column types from ActiveRecord
    class BaseColumnSchemas
      attr_reader :model, :only, :except

      # @param model [ActiveRecord::Base] the model to parse
      # @param only [Array<Symbol|String>] optionally parse only these columns
      # @param except [Array<Symbol|String>] optionally parse all columns except these
      # @param optional [Array<Symbol|String>] integrate attribute like methods in schema
      def initialize(model, only: [], except: [], methods: [])
        @model = model
        @only = only
        @except = except
        @methods = methods
      end

      def columns
        @columns ||= columns_to_map.to_h do |column|
          [
            column.name.to_sym,
            DbColumnTypeMap.send(column.cast_type.type, column)
          ]
        end
      end

      def method_props
        @method_props ||= @methods.index_with do |method|
          MethodReturnTypeMap.map(model_sample, method)
        end
      end

      def properties
        @properties ||= columns.merge(method_props)
      end

      private

      def model_sample
        @model_sample ||= model.first || model.new
      end

      def columns_to_map
        if only.any?
          only_columns
        elsif except.any?
          except_columns
        else
          model.columns
        end
      end

      def only_columns
        model.columns.select { |c| only.include?(c.name) }
      end

      def except_columns
        model.columns.reject { |c| except.include?(c.name) }
      end
    end
  end
end
