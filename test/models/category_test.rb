# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  abbr       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  position   :integer
#
require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "strips whitespace from name and abbr" do
    category = Category.new(name: "  Design  ", abbr: "  D  ")

    category.valid?

    assert_equal "Design", category.name
    assert_equal "D", category.abbr
  end
end
