# coding: utf-8
require "#{File.dirname(__FILE__)}/../spec_helper"

describe "tables access control" do
  def parse(q)
    Sql::QueryParser.new.parse q
  end

  def should_parse(q)
    r = parse(q)
    expect(r).not_to be_nil
    r
  end

  it "parses select without from clause" do
    t = should_parse("select 42")
    t.tables.should be_empty
  end

  it "parses select with from clause" do
    t = should_parse("select a from t")
    t.tables.should eq(["t"])
  end

  it "parses select with two tables" do
    t = should_parse("select a from t1, t2")
    t.tables.should eq(["t1","t2"])
  end

  it "parses select with subquery" do
    t = should_parse("select a from t1, (select b,c from d.t) t2")
    t.tables.should eq(["d.t","t1"])
  end

  it "parses select with natural join" do
    t = should_parse("select a,b from t1 natural inner join t2")
    t.tables.should eq(["t1","t2"])
  end

  it "parses select with multiple joins" do
    t = should_parse("select a,b from t1 join t2 using (a) right join t3 on (t2.b = t3.c)")
    t.tables.should eq(["t1","t2","t3"])
  end

  it "parses select with common table expression" do
    t = should_parse("with q as (select a,b from t1) select a,b,c from q natural join t2")
    t.tables.should eq(["t1","t2"])
  end

  it "parses select with common table expression and join" do
    t = should_parse("with q as (select a,b from t1 natural join t2) select c from q natural join t3")
    t.tables.should eq(["t1","t2","t3"])
  end

  it "parses select with common table expression and repeated table" do
    t = should_parse("with q as (select a,b from t1 natural join t2) select c from q natural join t2")
    t.tables.should eq(["t1","t2"])
  end

  it "parses combined select queries" do
    t = should_parse("select a from t1 union (select b from t2 union select c from t3)")
    t.tables.should eq(["t1","t2","t3"])
  end

  it "parses select with subquery" do
    t = should_parse("select a, 2 + (select max(b) from t2) from t1")
    t.tables.should eq(["t1","t2"])
  end
end
