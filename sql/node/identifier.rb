module Sql
  module Node
    module LiteralIdentifier
      def name
        text_value
      end
    end

    module QuotedIdentifier
      def name
        c.elements.map(&:char).join
      end
    end

    module IdentifierChar
      module Quote
        def char
          '"'
        end
      end
      module Text
        def char
          text_value
        end
      end
    end

    module QualifiedName
      def name
        [ schema_name.name, identifier.name ].join '.'
      end
    end

    module AllFields
      def name
        :all
      end
    end
  end
end
