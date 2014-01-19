require "#{File.dirname(__FILE__)}/spec_helper"

require 'sql/select'

describe Sql::SelectParser do

  let(:p) { Sql::SelectParser.new }

  it "works" do
    r = p.parse("with q as (select ax,bx,cx) select ax")
    puts r.value if r
    expect(r).not_to be_nil
  end
end
