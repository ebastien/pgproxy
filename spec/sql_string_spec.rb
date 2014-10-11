# coding: utf-8
require "#{File.dirname(__FILE__)}/spec_helper"

describe Sql::StringParser do
  def parse(q)
    Sql::StringParser.new.parse q
  end

  it "parses a string" do
    parse("'string'").should_not be_nil
  end

  it "parses a string with escaped quote" do
    parse("'str''ing'").should_not be_nil
  end

  it "parses a string in parts" do
    parse("'str' \n 'ing'").should_not be_nil
  end

  it "parses an extended string" do
    parse("E's\\tr''i\\ng'").should_not be_nil
  end

  it "parses a string with octal char value" do
    parse("e's\\123g'").should_not be_nil
  end

  it "parses a string with hexa char value" do
    parse("e's\\x7Fg'").should_not be_nil
  end

  it "parses a string with hexa char value" do
    parse("e's\\x1g'").should_not be_nil
  end

  it "parses a string with unicode char value" do
    parse("e's\\u007Fg'").should_not be_nil
  end

  it "parses a string with unicode char value" do
    parse("e's\\u0000007Fg'").should_not be_nil
  end
end
