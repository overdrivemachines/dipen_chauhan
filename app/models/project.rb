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
#
class Project < ApplicationRecord
  has_one_attached :image
end
