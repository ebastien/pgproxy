require "#{File.dirname(__FILE__)}/spec_helper"

require 'sql/select'

describe Sql::SelectParser do

  let(:p) { Sql::SelectParser.new }

  it "works" do
    q = """
with q as (
  select ax, bx, cx from my_table as t
) select ax from q
"""
    r = p.parse(q)
    puts r.value if r
    expect(r).not_to be_nil
  end
end
