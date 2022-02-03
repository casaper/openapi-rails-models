# frozen_string_literal: true

module Openapi
  module Models
    class ParseDbColumnType
      class << self
        def integer(column)
          # TODO: recognize foreign key and add description mentioning model related to type
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
end
