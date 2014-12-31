module Sql
  module Node
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

    module AmbiguousOperator
      def value
        ( r.elements.map { |e| e.op_char.value } + [op_char.value] ).join.to_sym
      end
    end
  end
end
