require "#{File.dirname(__FILE__)}/spec_helper"

require 'sql/select'

describe Sql::SelectParser do

  def parse(q)
    r = Sql::SelectParser.new.parse q
    puts r if r
    r
  end

  it "parses select without from clause" do
    t = parse("select a")
    t.should_not be_nil
    t.tables.should be_empty
  end

  it "parses select with from clause" do
    parse("select a from t").should_not be_nil
  end

  it "parses select with two tables" do
    parse("select a from t1, t2").should_not be_nil
  end

  it "parses select with from and where clauses" do
    parse("select a from t where b + 1 = a and a > 2").should_not be_nil
  end

  it "parses select with subquery" do
    parse("select a from t, (select b,c from d.t)").should_not be_nil
  end

  it "parses select with join" do
    parse("select a,b from t1 inner join t2 on (t1.a = t2.a)").should_not be_nil
  end

  it "works" do
    parse("""
with q as (
  select ax, bx, cx from my_table as t
) select ax from q
""").should_not be_nil
  end
end
