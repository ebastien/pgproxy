# coding: utf-8
require "#{File.dirname(__FILE__)}/../../spec_helper"

describe Sql::ExpressionParser do
  def parse(q)
    r = Sql::ExpressionParser.new.parse q, root: :query
    puts r if r
    r
  end

  it "parses select without from clause" do
    t = parse("select 42")
    t.should_not be_nil
    t.tables.should be_empty
  end

  it "parses select with from clause" do
    t = parse("select a from t")
    t.should_not be_nil
    t.tables.should eq(["t"])
  end

  it "parses select all columns" do
    t = parse("select * from t")
    t.should_not be_nil
    t.tables.should eq(["t"])
  end

  it "parses select with two tables" do
    t = parse("select a from t1, t2")
    t.should_not be_nil
    t.tables.should eq(["t1","t2"])
  end

  it "parses select with from and where clauses" do
    t = parse("select a from t where b + 1 = a and a > 2")
    t.should_not be_nil
    t.tables.should eq(["t"])
  end

  it "parses select with subquery" do
    t = parse("select a from t1, (select b,c from d.t) t2")
    t.should_not be_nil
    t.tables.should eq(["d.t","t1"])
  end

  it "reject select with subquery without alias" do
    t = parse("select a from t1, (select b,c from d.t)")
    t.should be_nil
  end

  it "parses select with natural join" do
    t = parse("select a,b from t1 natural inner join t2")
    t.should_not be_nil
    t.tables.should eq(["t1","t2"])
  end

  it "parses select with inner join" do
    t = parse("select a,b from t1 inner join t2 on (t1.a = t2.a)")
    t.should_not be_nil
    t.tables.should eq(["t1","t2"])
  end

  it "parses select with outer join" do
    t = parse("select a,b from t1 full outer join t2 using (a,b)")
    t.should_not be_nil
    t.tables.should eq(["t1","t2"])
  end

  it "parses select with multiple joins" do
    t = parse("select a,b from t1 join t2 using (a) right join t3 on (t2.b = t3.c)")
    t.should_not be_nil
    t.tables.should eq(["t1","t2","t3"])
  end

  it "parses select with alias on tables" do
    t = parse("select a,b from t1 as x natural join t2 as y")
    t.should_not be_nil
    t.tables.should eq(["t1","t2"])
  end

  it "parses select with alias on join" do
    t = parse("select a,b from (t1 natural join t2) as t3")
    t.should_not be_nil
    t.tables.should eq(["t1","t2"])
  end

  it "reject select with sub-join without alias" do
    t = parse("select a,b from (t1 natural join t2)")
    t.should be_nil
  end

  it "parses select with column alias" do
    t = parse("select a,b,c from long_table t (a,b,c)")
    t.should_not be_nil
    t.tables.should eq(["long_table"])
  end

  it "parses select with common table expression" do
    t = parse("with q as (select a,b from t1) select a,b,c from q natural join t2")
    t.should_not be_nil
    t.tables.should eq(["t1","t2"])
  end

  it "parses select with common table expression and join" do
    t = parse("with q as (select a,b from t1 natural join t2) select c from q natural join t3")
    t.should_not be_nil
    t.tables.should eq(["t1","t2","t3"])
  end

  it "parses select with common table expression and repeated table" do
    t = parse("with q as (select a,b from t1 natural join t2) select c from q natural join t2")
    t.should_not be_nil
    t.tables.should eq(["t1","t2"])
  end

  it "parses select with scalar subquery" do
    t = parse("SELECT name, (SELECT max(pop) FROM cities WHERE cities.state = states.name) FROM states")
    t.should_not be_nil
    t.tables.should eq(["cities","states"])
  end

  it "parses combined select queries" do
    expect(parse("select a from t1 union select b from t2")).not_to be_nil
    expect(parse("select a from t1 union all select b from t2")).not_to be_nil
    expect(parse("select a from t1 union select b from t2 union select c from t3")).not_to be_nil
    expect(parse("select a from t1 union (select b from t2 union select c from t3)")).not_to be_nil
    expect(parse("select a from t1 intersect select b from t2")).not_to be_nil
    expect(parse("select a from t1 except select b from t2")).not_to be_nil
  end
end
