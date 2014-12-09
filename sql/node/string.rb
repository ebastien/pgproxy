module Sql
  module Node
    module MultiString
      def value
        ([single_string.value] + \
          t.elements.map do |e|
            e.single_string.value
          end
        ).join
      end
    end

    module Character
      module Quote
        def value
          "'"
        end
      end
      module Text
        def value
          text_value
        end
      end
      module ExtEscape
        def value
          c.value
        end
      end
      module NotImplemented
        def value
          ""
        end
      end
    end

    module StringConstant
      def value
        c.elements.map(&:value).join
      end
    end
  end
end
