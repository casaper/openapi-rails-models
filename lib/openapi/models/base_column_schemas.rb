# frozen_string_literal: true

module OpenApi
  module Models
    # Parse main column types from ActiveRecord
    class BaseColumnSchemas
      attr_reader :model, :only, :except

      # @param model [ActiveRecord::Base] the model to parse
      # @param only [Array<Symbol|String>] optionally parse only these columns
      # @param except [Array<Symbol|String>] optionally parse all columns except these
      def initialize(model, only: [], except: [])
        @model = model
        @only = only
        @except = except
      end

      def columns
        @columns ||= columns_to_map.to_h do |column|
          [
            column.name.to_sym,
            send(column.cast_type.type, column)
          ]
        end
      end

      private

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

      def integer(column)
        {
          type: 'integer',
          format: column.cast_type.limit == 8 ? 'int64' : 'int32',
          minimum: column.cast_type.instance_variable_get(:@range).first,
          maximum: column.cast_type.instance_variable_get(:@range).last
        }
      end

      def float(_column)
        { type: 'number', format: 'float' }
      end

      def decimal(column)
        if column.cast_type.is_a? ActiveRecord::Type::DecimalWithoutScale
          { type: 'integer' }
        else
          { type: 'string', format: '(-\d+\.\d+|\d+\.\d+|-\d+|\d+)' }
        end
      end

      def boolean(_column)
        { type: 'boolean' }
      end

      def string(column)
        { type: 'string', maxLength: column.limit }
      end
      alias text string

      def time(_column)
        { type: 'string', format: 'date-time' }
      end
      alias datetime time

      def date(_column)
        { type: 'string', format: 'date' }
      end
    end
  end
end
