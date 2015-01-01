# coding: utf-8
require "#{File.dirname(__FILE__)}/../spec_helper"

describe Sql::OperatorParser do
  def parse(q)
    r = Sql::OperatorParser.new.parse q
    expect(r).not_to be_nil
    r
  end

  def reject(q)
    r = Sql::OperatorParser.new.parse q
    expect(r).to be_nil
  end

  it "parses operators" do
    expect(parse("=!=").operator).to eq(:"=!=")
    expect(parse("<~&").operator).to eq(:"<~&")
    expect(parse("</*~&*/").operator).to eq(:"<")
    expect(parse("</*~&*/!").operator).to eq(:"<!")
    expect(parse("<--~&").operator).to eq(:"<")
    expect(parse("<?-").operator).to eq(:"<?-")
    expect(parse("/").operator).to eq(:"/")
    expect(parse("!").operator).to eq(:"!")
    expect(parse("/>").operator).to eq(:"/>")
    expect(parse("+").operator).to eq(:"+")
    expect(parse("<!>++").operator).to eq(:"<!>++")
    expect(parse("<!>+=").operator).to eq(:"<!>+=")
    reject(">=-")
  end
end
