require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "the johnniness of johnny" do
    p = Fabricate(:person, :name => "johnny")
    assert p.name == "johnny"
  end
end
