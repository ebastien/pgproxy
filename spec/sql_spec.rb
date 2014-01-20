require "#{File.dirname(__FILE__)}/spec_helper"

require 'sql/select'

describe Sql::SelectParser do

  def parse(q)
    r = Sql::SelectParser.new.parse q
    puts r.value if r
    r
  end

  it "parses select without from clause" do
    parse("select a").should_not be_nil
  end

  it "parses select with from clause" do
    parse("select a from t").should_not be_nil
  end

  it "parses select with from and where clauses" do
    parse("select a from t where a = 1").should_not be_nil
  end

  it "works" do
    parse("""
with q as (
  select ax, bx, cx from my_table as t
) select ax from q
""").should_not be_nil
  end
end
