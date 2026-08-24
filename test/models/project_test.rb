# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  title         :string
#  description   :string
#  live_url      :string
#  display_order :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :integer          not null
#  code_url      :string
#  position      :integer
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
