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
class Project < ApplicationRecord
  has_one_attached :image
  belongs_to :category
  before_save :remove_space
  acts_as_list # acts_as_list gem
  default_scope { order(position: :asc) }

  validates :category_id, presence: true
  validates :title, :description, :code_url, :live_url, presence: true
  validates :live_url, url: true # using validate_url gem
  validates :code_url, url: true # using validate_url gem

  private

  def remove_space
    title.strip
    description.strip
    live_url.strip
    code_url.strip
  end
end
