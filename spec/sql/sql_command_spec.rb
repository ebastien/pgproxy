# coding: utf-8
require "#{File.dirname(__FILE__)}/../spec_helper"

describe Sql::CommandParser do
  def parse(q)
    Sql::CommandParser.new.parse q
  end

  it "parses a single query" do
    t = parse("select a;")
    expect(t).not_to be_nil
  end

  it "parses multiple queries" do
    t = parse("select a; select b")
    expect(t).not_to be_nil
  end

  it "parses queries with comment" do
    t = parse("select /* comment */ a; select b")
    expect(t).not_to be_nil
  end
end
