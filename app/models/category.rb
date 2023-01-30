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
class Category < ApplicationRecord
  has_many :projects
  # Before a category is destroyed, all projects of this category
  # need to be reassigned different categories
  before_destroy :reassign_projects_category
  acts_as_list # acts_as_list gem
  default_scope { order(position: :asc) }

  validates :name, presence: true
  validates :abbr, presence: true

  private

  # Callback called before destroy
  # Do not destroy when only one category is left
  # Do not destroy "Hidden" category
  # when a category is destroyed, assign the foreign keys of
  # Projects to the hidden category
  def reassign_projects_category
    return false if Category.count == 1
    return false if abbr == "Hidden"

    projects.each do |project|
      project.category_id = Category.find_by(abbr: "Hidden").id
      project.save
    end
  end
end
