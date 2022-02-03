# frozen_string_literal: true

module Openapi
  module Models
    class MethodReturnTypeMap
      class << self
        TYPE_MAP_NO_RECURSION = {
          Integer => :integer,
          Float => :float,
          Time => :time,
          Date => :date,
          DateTime => :time,
          Boolean => :boolean,
          BigDecimal => :decimal,
          String => :string,
          Symbol => :string,
          Array => :array_no_recursion,
          Hash => :object_no_recursion
        }.freeze
        TYPE_MAP = TYPE_MAP_NO_RECURSION.merge(
          Array => :array,
          Hash => :object
        )

        def map(sample, method)
          result = sample.send(method)
          send(TYPE_MAP[result.class], result)
        end

        def array(result = [])
          { type: 'array', items: array_result_items(result) }
        end

        def array_result_items(result = [])
          if result.size.zero?
            {}
          elsif result.map(&:class).uniq.size == 1
            send(TYPE_MAP_NO_RECURSION[result.first.class])
          else
            array_items_one_of(result)
          end
        end

        def array_items_one_of(result)
          {
            oneOf: result.map { |i| [i.class, i] }
                         .uniq_by(&:first)
                         .map { |type, val| send(TYPE_MAP_NO_RECURSION[type], val) }
                         .uniq
          }
        end

        def array_no_recursion(_result)
          array
        end

        def object(result = {})
          {
            type: 'object',
            required: [],
            properties: result.transform_values do |val|
              send(TYPE_MAP_NO_RECURSION[val.class], val)
            end
          }
        end

        def object_no_recursion(_result = nil)
          { type: 'object', properties: {}, required: [] }
        end

        def integer(_result = nil)
          { type: 'integer' }
        end

        def float(_result = nil)
          { type: 'number', format: 'float' }
        end

        def decimal(_result = nil)
          { type: 'string', format: '(-\d+\.\d+|\d+\.\d+|-\d+|\d+)' }
        end

        def boolean(_result = nil)
          { type: 'boolean' }
        end

        def string(_result = nil)
          { type: 'string' }
        end
        alias text string

        def time(_result = nil)
          { type: 'string', format: 'date-time' }
        end
        alias datetime time

        def date(_result = nil)
          { type: 'string', format: 'date' }
        end
      end
    end
  end
end
