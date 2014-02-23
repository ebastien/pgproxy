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
    parse("select a from t1, (select b,c from d.t) t2").should_not be_nil
  end

  it "parses select with natural join" do
    parse("select a,b from t1 natural inner join t2").should_not be_nil
  end

  it "parses select with inner join" do
    parse("select a,b from t1 inner join t2 on (t1.a = t2.a)").should_not be_nil
  end

  it "parses select with outer join" do
    parse("select a,b from t1 full outer join t2 using (a,b)").should_not be_nil
  end

  it "parses select with multiple joins" do
    parse("select a,b from t1 join t2 using (a) right join t3 on (t2.b = t3.c)").should_not be_nil
  end

  it "parses select with alias on tables" do
    parse("select a,b from t1 as x natural join t2 as y").should_not be_nil
  end

  it "parses select with alias on join" do
    parse("select a,b from (t1 natural join t2) as t3").should_not be_nil
  end

  it "parses select with column alias" do
    parse("select a,b,c from long_table t (a,b,c)").should_not be_nil
  end

  it "parses select with common table expression" do
    parse("with q as (select a,b from t1) select a,b,c from q natural join t2").should_not be_nil
  end
end
