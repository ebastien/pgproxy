# coding: utf-8
require "#{File.dirname(__FILE__)}/../../spec_helper"

describe Sql::ExpressionParser do
  def parse(q)
    r = Sql::ExpressionParser.new.parse q, root: :select_section
    expect(r).not_to be_nil
    r
  end

  it "parses select section" do
    t = parse("select t.column from table t")
    t.tables.should eq([["t", ["table"]]])
  end

  it "parses select section with global aggregation" do
    t = parse("select count(*) from t")
  end

  it "parses select section with subquery" do
    t = parse("select a, 2 + (select max(b) from t2) from t1")
    t.tables.should eq(["t2", ["t1", ["t1"]]])
  end

  it "parses select section asking for all columns" do
    parse("select t.* from t")
  end

  it "parses select section with column label" do
    parse("select a as x, b+c as y from t")
    parse("select a \"x\", b+c y from t")
  end

  it "parses select section with distinct" do
    parse("select distinct a,b from t")
    parse("select distinct on (a+b,c) a,b,c from t")
  end

  it "parses select section with group by" do
    parse("select a,b,min(c) from t group by a,b")
    parse("select a,b,min(c) from t group by a,b having a+b>10")
  end

  it "parses select section with order by" do
    parse("select a,b from t order by a+b,c DESC NULLS LAST")
    parse("select a,b from t order by a+b,c ASC NULLS FIRST")
  end
end
