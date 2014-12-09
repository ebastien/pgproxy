module Sql
  module Node
    module PositionalParam
      def value
        [:p, digits.value]
      end
    end

    module NumericLiteral
      def value
        decimal_literal.value * (10 ** exponent_literal.value)
      end
    end

    module DecimalLiteral
      def value
        text_value.to_f
      end
    end

    module ExponentLiteral
      def value
        digits.value * ( s.text_value == '-' ? -1 : 1 )
      end
    end

    module Digits
      def value
        text_value.to_i
      end
    end

    module Boolean
      module True
        def value
          true
        end
      end
      module False
        def value
          false
        end
      end
    end
  end
end
