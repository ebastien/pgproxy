module Sql
  module Node
    module GenExpression
      def tables
        gen_value.tables + r.elements.flat_map { |e| e.gen_value.tables }
      end
    end

    module GenValue
      module Literal
        def tables
          []
        end
      end
      module Subscript
        def tables
          field_selection.tables + r.elements.flat_map do |e|
            e.range_expression.tables
          end
        end
      end
    end

    module FunctionCall
      def tables
        function_params.tables
      end
    end

    module TypeCast
      def tables
        scalar_expression.tables
      end
    end

    module VoidExpression
      def tables
        []
      end
    end

    module AggregateExpression
      def tables
        expressions_list.tables + order_by_clause.tables
      end
    end

    module OrderByClause
      def tables
        respond_to?(:expressions_list) ? expressions_list.tables : []
      end
    end

    module ExpressionsList
      def tables
        gen_expression.tables + r.elements.flat_map do |e|
          e.gen_expression.tables
        end
      end
    end

    module NamedExpressionsList
      def tables
        named_expression.tables + r.elements.flat_map do |e|
          e.named_expression.tables
        end
      end
    end

    module NamedExpression
      def tables
        gen_expression.tables
      end
    end

    module AllColumns
      def tables
        []
      end
    end

    module RangeExpression
      def tables
        b.tables + e.tables
      end
    end

    module FieldSelection
      def tables
        row_value.tables
      end
    end

    module RowValue
      module Query
        def tables
          query_expression.tables
        end
      end
      module Expression
        def tables
          gen_expression.tables
        end
      end
      module Identifier
        def tables
          []
        end
      end
    end

    module QueryExpression
      def tables
        query_value.tables + r.elements.flat_map { |e| e.query_value.tables }
      end
    end

    module QueryValue
      module Expression
        def tables
          query_expression.tables
        end
      end
      module Select
      end
    end

    module SelectQuery
      def tables
        select_list.tables + table_expression.tables
      end
    end

    module TableExpression
      def tables
        from_clause.tables
      end
    end

    module FromClause
      def tables
        respond_to?(:table_references) ? table_references.tables : []
      end
    end

    module TableReferences
      def tables
        table_joins.tables + r.elements.flat_map { |e| e.table_joins.tables }
      end
    end

    module TableJoins
      def tables
        [table_reference.table] + r.elements.map { |e| e.joined_table.table }
      end
    end

    module TableReference
      def table
        if respond_to?(:table_spec)
          [ table_name.name, table_spec.tables ]
        else
          [ name, [name] ]
        end
      end
    end

    module TableSpec
      module Query
        def tables
          query_expression.tables
        end
      end
      module Joins
        def tables
          table_joins.tables
        end
      end
      module Table
        def tables
          [name]
        end
      end
    end

    module Join
      def table
        table_reference.table
      end
    end
  end
end
