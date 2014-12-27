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
end
