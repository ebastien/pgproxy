require File.expand_path("#{File.dirname(__FILE__)}/spec_helper")

Treetop.load File.expand_path("#{File.dirname(__FILE__)}/../sql")

describe SqlParser do

  let(:p) { SqlParser.new }

  it "works" do
    r = p.parse("with q as (select ax,bx,cx) select ax")
    expect(r).not_to be_nil
  end
end
