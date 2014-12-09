module Sql
  module Node
    module WildcardIdentifier
      def name
        :all
      end
    end

    module LiteralIdentifier
      def name
        text_value
      end
    end

    module QuotedIdentifier
      def name
        c.elements.map(&:character).join
      end
    end

    module IdentifierChar
      module Quote
        def character
          '"'
        end
      end
      module Text
        def character
          text_value
        end
      end
    end

    module QualifiedName
      def name
        [ schema_name.name, identifier.name ].join '.'
      end
    end
  end
end
