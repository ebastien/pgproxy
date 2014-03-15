require "#{File.dirname(__FILE__)}/spec_helper"

require 'sql/simple_expression'

describe Sql::ExpressionParser do
  def parse(q)
    r = Sql::ExpressionParser.new.parse q
    expect(r).not_to be_nil
    r
  end

  it "parses a column name" do
    e = parse("a")
    e.value.should eq(["a"])
  end

  it "parses a qualified column name" do
    e = parse("my_table.my_column")
    e.value.should eq(["my_table:my_column"])
  end

  it "parses an integer" do
    e = parse("42")
    e.value.should eq([42])
  end

  it "parses a boolean" do
    e = parse("true")
    e.value.should eq([true])
  end

  it "parses a string" do
    e = parse("'42'")
    e.value.should eq(["42"])
  end

  it "parses an integer" do
    expect(parse("42").value).to eq([42])
  end

  it "parses a float" do
    expect(parse("42.56").value).to eq([42.56])
  end

  it "parses a float w/o unit" do
    expect(parse(".56").value).to eq([0.56])
  end

  it "parses an exponent notation" do
    expect(parse("42.56e-3").value).to eq([0.04256])
  end

  it "parses an unusual exponent notation" do
    expect(parse("42.e3").value).to eq([42000])
  end
end
