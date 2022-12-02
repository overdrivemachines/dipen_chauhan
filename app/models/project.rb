# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  title         :string
#  description   :string
#  url           :string
#  display_order :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :integer          not null
#
class Project < ApplicationRecord
  has_one_attached :image
  belongs_to :category
  before_save :remove_space

  validates :category_id, presence: true
  validates :title, :description, :url, presence: true
  validates :url, url: true # using validate_url gem

  private

  def remove_space
    title.strip
    description.strip
    url.strip
  end
end
