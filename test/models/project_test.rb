# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  code_url      :string
#  description   :string
#  display_order :integer
#  featured      :boolean          default(FALSE)
#  live_url      :string
#  position      :integer
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :integer          not null
#
# Foreign Keys
#
#  category_id  (category_id => categories.id)
#
require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "strips whitespace from text attributes" do
    project = Project.new(
      title: "  My Project  ",
      description: "  Clean description  ",
      code_url: "  https://github.com/example/code  ",
      live_url: "  https://example.com  ",
      category: categories(:one)
    )

    project.valid?

    assert_equal "My Project", project.title
    assert_equal "Clean description", project.description
    assert_equal "https://github.com/example/code", project.code_url
    assert_equal "https://example.com", project.live_url
  end
end
