module Sql
  module Node
    module TypeName
      def name
        text_value.to_sym
      end
    end
  end
end
