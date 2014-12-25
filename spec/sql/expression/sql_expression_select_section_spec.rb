# coding: utf-8
require "#{File.dirname(__FILE__)}/../../spec_helper"

describe Sql::ExpressionParser do
  def parse(q)
    r = Sql::ExpressionParser.new.parse q, root: :select_section
    puts r if r
    r
  end

  it "parses select section" do
    t = parse("select t.column from table t")
    t.should_not be_nil
    t.tables.should eq([["t", ["table"]]])
  end

  it "parses select section with global aggregation" do
    t = parse("select count(*) from t")
    t.should_not be_nil
  end

  it "parses select section with subquery" do
    t = parse("select a, 2 + (select max(b) from t2) from t1")
    t.should_not be_nil
    t.tables.should eq(["t2", ["t1", ["t1"]]])
  end
end
