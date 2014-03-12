# coding: utf-8
require "#{File.dirname(__FILE__)}/spec_helper"

require 'sql/identifier'

describe Sql::IdentifierParser do
  def parse(q)
    Sql::IdentifierParser.new.parse q
  end

  it "parses simple identifier" do
    t = parse("my_$IdenTifieR_éあいうï")
    expect(t).not_to be_nil
    expect(t.name).to eq("my_$IdenTifieR_éあいうï")
  end

  it "rejects invalid identifier" do
    t = parse("my_invalid-IdenTifieR")
    expect(t).to be_nil
  end
end
