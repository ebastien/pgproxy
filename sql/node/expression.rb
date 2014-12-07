module Sql
  module Node
    module GenExpression
      def value
        r.elements.map { |e| e.gen_term.value }
      end
    end

    module GenOperator
      def value
        text_value.to_sym
      end
    end

    module GenValue
      module Literal
      end
      module Function
      end
      module Subscript
        def value
          [:s, field_selection.value] + r.elements.map do |e|
            e.range_expression.value
          end
        end
      end
      module Field
      end
    end

    module FunctionCall
      def value
        [function_name.name] + function_params.value
      end
    end

    module TypeCast
      def value
        [type_name.name, scalar_expression.value]
      end
    end

    module TypeName
      def name
        text_value.to_sym
      end
    end

    module VoidExpression
      def value
        []
      end
    end

    module AggregateExpression
      def value
        [:a, expressions_list.value, order_by_clause.value]
      end
    end

    module OrderByClause
      def value
        expressions_list.value
      end
    end

    module ExpressionsList
      def value
        [gen_expression.value] + r.elements.map do |e|
          e.gen_expression.value
        end
      end
    end

    module RangeExpression
      def value
        [:r, b.value, e.value]
      end
    end

    module FieldSelection
      def value
        [:f, row_value.value, identifier.name]
      end
    end

    module RowValue
      module Query
        def value
          select_query.text_value
        end
      end
      module Expression
        def value
          gen_expression.value
        end
      end
      module Positional
      end
      module Identifier
        def value
          name
        end
      end
    end
  end
end
