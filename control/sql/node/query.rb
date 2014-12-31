module Sql
  module Node
    module Query
      def common_tables
        Hash[ with_section.tables.map { |t| [t.first, expand_table(t)] } ]
      end

      def tables
        cte = common_tables
        query_expression.tables.flat_map { |t| expand_table(t) }
                               .flat_map { |t| cte[t] || [t] }
                               .sort.uniq
      end

      def expand_table(t)
        a, b = t
        b ? b.flat_map { |x| expand_table(x) } : [a]
      end
    end

    module WithSection
      def tables
        respond_to?(:with_queries) ? with_queries.tables : []
      end
    end

    module WithQueries
      def tables
        [with_query.table] + r.elements.map { |e| e.with_query.table }
      end
    end

    module WithQuery
      def table
        [ identifier.name, query_expression.tables ]
      end
    end
  end
end
