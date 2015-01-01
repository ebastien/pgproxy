# coding: utf-8
require "#{File.dirname(__FILE__)}/../spec_helper"

describe Sql::QueryParser do
  def parse(q)
    Sql::QueryParser.new.parse q
  end

  def should_parse(q)
    r = parse(q)
    expect(r).not_to be_nil
    r
  end

  def should_not_parse(q)
    r = parse(q)
    expect(r).to be_nil
    r
  end

  it "parses select without from clause" do
    should_parse("select 42")
  end

  it "parses select with from clause" do
    should_parse("select a from t")
  end

  it "parses select all columns" do
    should_parse("select * from t")
  end

  it "parses select with two tables" do
    should_parse("select a from t1, t2")
  end

  it "parses select with from and where clauses" do
    should_parse("select a from t where b + 1 = a and a > 2")
  end

  it "parses select with subquery" do
    should_parse("select a from t1, (select b,c from d.t) t2")
  end

  it "rejects select with subquery without alias" do
    should_not_parse("select a from t1, (select b,c from d.t)")
  end

  it "parses select with natural join" do
    should_parse("select a,b from t1 natural inner join t2")
  end

  it "parses select with inner join" do
    should_parse("select a,b from t1 inner join t2 on (t1.a = t2.a)")
  end

  it "parses select with outer join" do
    should_parse("select a,b from t1 full outer join t2 using (a,b)")
  end

  it "parses select with multiple joins" do
    should_parse("select a,b from t1 join t2 using (a) right join t3 on (t2.b = t3.c)")
  end

  it "parses select with alias on tables" do
    should_parse("select a,b from t1 as x natural join t2 as y")
  end

  it "parses select with alias on join" do
    should_parse("select a,b from (t1 natural join t2) as t3")
  end

  it "rejects select with sub-join without alias" do
    should_not_parse("select a,b from (t1 natural join t2)")
  end

  it "parses select with column alias" do
    should_parse("select a,b,c from long_table t (a,b,c)")
  end

  it "parses select with common table expression" do
    should_parse("with q as (select a,b from t1) select a,b,c from q natural join t2")
  end

  it "parses select with common table expression and join" do
    should_parse("with q as (select a,b from t1 natural join t2) select c from q natural join t3")
  end

  it "parses select with common table expression and repeated table" do
    should_parse("with q as (select a,b from t1 natural join t2) select c from q natural join t2")
  end

  it "parses combined select queries" do
    should_parse("select a from t1 union select b from t2")
    should_parse("select a from t1 union all select b from t2")
    should_parse("select a from t1 union select b from t2 union select c from t3")
    should_parse("select a from t1 union (select b from t2 union select c from t3)")
    should_parse("select a from t1 intersect select b from t2")
    should_parse("select a from t1 except select b from t2")
  end

  it "parses select with table alias" do
    should_parse("select t.column from table t")
  end

  it "parses select with global aggregation" do
    should_parse("select count(*) from t")
  end

  it "parses select with subquery" do
    should_parse("select a, 2 + (select max(b) from t2) from t1")
  end

  it "parses select asking for all columns" do
    should_parse("select t.* from t")
  end

  it "parses select with column label" do
    should_parse("select a as x, b+c as y from t")
    should_parse("select a \"x\", b+c y from t")
  end

  it "parses select with distinct" do
    should_parse("select distinct a,b from t")
    should_parse("select distinct on (a+b,c) a,b,c from t")
  end

  it "parses select with group by" do
    should_parse("select a,b,min(c) from t group by a,b")
    should_parse("select a,b,min(c) from t group by a,b having a+b>10")
  end

  it "parses select with order by" do
    should_parse("select a,b from t order by a+b,c DESC NULLS LAST")
    should_parse("select a,b from t order by a+b,c ASC NULLS FIRST")
  end

  it "parses select with limit and offset" do
    pending("not implemented")
  end
end
