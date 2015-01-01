module Sql
  module Node
    module KeywordOperator
      def operator
        text_value.to_sym
      end
    end

    module OperatorChar
      def char
        c.text_value
      end
    end

    module SingleCharOperator
      def operator
        c.char.to_sym
      end
    end

    module SignEndingOperator
      def operator
        ( unless b.empty?
            b.r.elements.map { |e| e.basic_op_char.char } + [b.basic_op_char.char]
          else
            []
          end + [special_op_char.char] + \
          unless o.empty?
            o.r.elements.map { |e| e.op_char.char } + [o.op_char.char]
          else
            []
          end + [sign_op_char.char]
        ).join.to_sym
      end
    end

    module NonsignEndingOperator
      def operator
        ( r.elements.map { |e| e.op_char.char } +
          [op_char.char] + [nonsign_op_char.char]
        ).join.to_sym
      end
    end

    module AmbiguousOperator
      def operator
        ( r.elements.map { |e| e.op_char.char } + [op_char.char] ).join.to_sym
      end
    end
  end
end
