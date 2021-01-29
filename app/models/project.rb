# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  status     :integer          default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint           not null
#  show_id    :bigint           not null
#
# Indexes
#
#  index_projects_on_group_id              (group_id)
#  index_projects_on_group_id_and_show_id  (group_id,show_id) UNIQUE
#  index_projects_on_show_id               (show_id)
#  index_projects_on_status                (status)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (show_id => shows.id)
#
class Project < ApplicationRecord
  before_destroy :cleanup_shows

  belongs_to :show
  belongs_to :group

  enum status: {
    pending: 0,
    accepted: 1,
    declined: 2
  }

  private
    def cleanup_shows
      show.destroy if show.projects.where(status: :accepted).size == 0
    end
end
