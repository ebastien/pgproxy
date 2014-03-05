require "#{File.dirname(__FILE__)}/spec_helper"

require 'sql/simple_expression'

describe Sql::ExpressionParser do
  def parse(q)
    Sql::ExpressionParser.new.parse q
  end

  it "parses a column name" do
    e = parse("a")
    e.should_not be_nil
    e.value.should eq(["a"])
  end

  it "parses a qualified column name" do
    e = parse("my_table.my_column")
    e.should_not be_nil
    e.value.should eq(["my_table:my_column"])
  end

  it "parses a literal integer" do
    e = parse("42")
    e.should_not be_nil
    e.value.should eq([42])
  end

  it "parses a literal boolean" do
    e = parse("true")
    e.should_not be_nil
    e.value.should eq([true])
  end

  it "parses a literal string" do
    e = parse("'42'")
    e.should_not be_nil
    e.value.should eq(["42"])
  end
end
