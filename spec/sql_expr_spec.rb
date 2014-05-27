require "#{File.dirname(__FILE__)}/spec_helper"

require 'sql/simple_expression'

describe Sql::ExpressionParser do
  def parse(q)
    r = Sql::ExpressionParser.new.parse q
    expect(r).not_to be_nil
    puts r.value.inspect
    r
  end

  it "parses a column name" do
    e = parse("a")
    e.value.should eq(["a"])
  end

  it "parses a qualified column name" do
    e = parse("my_table.my_column")
    e.value.should eq([[:f, "my_table", "my_column"]])
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
    expect(parse(".56").value).to eq([0.56])
  end

  it "parses an exponent notation" do
    expect(parse("42.56e-3").value).to eq([0.04256])
    expect(parse("42.e3").value).to eq([42000])
  end

  it "parses arithmetic" do
    parse("-42 * (3.5 - 9 / t.b) + t.a")
  end

  it "parses positional parameters" do
    parse("$1 + $2")
  end

  it "parses subscript expressions" do
    parse("table.column[42 + 1]")
    parse("mytable.arraycolumn[4]")
    parse("mytable.two_d_column[17][34]")
    parse("$1[10:42]")
    parse("(arrayfunction(a,b))[42]")
  end

  it "parses function calls" do
    parse("sqrt(2)")
    parse("somefunction(2,42, \"some, string\")")
  end

  it "parses field selections" do
    parse("$1.somecolumn")
    parse("(compositecol).somecolumn")
    parse("(compositecol).*")
    parse("(rowfunction(a,b)).col3")
    parse("(compositecol).somefield")
    parse("(mytable.compositecol).somefield")
  end

  it "parses aggregate function calls" do
    parse("array_agg(a ORDER BY b,c)")
    parse("array_agg(ALL a, b ORDER BY c DESC)")
    parse("array_agg(DISTINCT a ORDER BY b ASC)")
    parse("array_agg(*)")
    parse("string_agg(a, ',' ORDER BY a)")
  end

  it "parses type casts" do
    parse("CAST( a AS integer )")
  end

  it "parses logical expressions" do
    parse("a AND b OR NOT c")
  end
end
