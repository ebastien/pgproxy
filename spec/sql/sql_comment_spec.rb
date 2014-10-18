# coding: utf-8
require "#{File.dirname(__FILE__)}/../spec_helper"

describe Sql::CommentParser do
  def parse(q)
    r = Sql::CommentParser.new.parse q
    expect(r).not_to be_nil
    r
  end

  def reject(q)
    expect(Sql::CommentParser.new.parse q).to be_nil
  end

  it "parses a C comment" do
    parse "/* a comment */"
  end

  it "parses a nested C comment" do
    parse "/* a /* nested */ comment */"
  end

  it "rejects an invalid C comment" do
    reject "/* an /* invalid comment */"
  end

  it "parses a line comment" do
    parse "-- a line -- comment\n"
  end

  it "rejects an invalid line comment" do
    reject "-- an invalid line \n comment\n"
  end
end
