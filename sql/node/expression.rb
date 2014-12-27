module Sql
  module Node
    module GenExpression
      def value
        h.elements.map { |e| e.gen_operator.value } +
        [gen_value.value] +
        r.elements.flat_map do |e|
          e.o.elements.map { |p| p.gen_operator.value } + [e.gen_value.value]
        end +
        t.elements.map { |e| e.gen_operator.value }
      end
    end

    module KeywordOperator
      def value
        text_value.to_sym
      end
    end

    module OperatorChar
      def value
        c.text_value
      end
    end

    module SingleCharOperator
      def value
        c.value.to_sym
      end
    end

    module SignEndingOperator
      def value
        ( unless b.empty?
            b.r.elements.map { |e| e.basic_op_char.value } + [b.basic_op_char.value]
          else
            []
          end + [special_op_char.value] + \
          unless o.empty?
            o.r.elements.map { |e| e.op_char.value } + [o.op_char.value]
          else
            []
          end + [sign_op_char.value]
        ).join.to_sym
      end
    end

    module NonsignEndingOperator
      def value
        ( r.elements.map { |e| e.op_char.value } +
          [op_char.value] + [nonsign_op_char.value]
        ).join.to_sym
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

    module NamedExpressionsList
      def value
        [named_expression.value] + r.elements.map do |e|
          e.named_expression.value
        end
      end
    end

    module NamedExpression
      def value
        if respond_to?(:column_name)
          [column_name.name, gen_expression.value]
        else
          gen_expression.value
        end
      end
    end

    module AllColumns
      def value
        [:all]
      end
    end

    module RangeExpression
      def value
        [:r, b.value, e.value]
      end
    end

    module FieldSelection
      def value
        [:f, row_value.value, field_identifier.name]
      end
    end

    module AllFields
      def name
        :all
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
