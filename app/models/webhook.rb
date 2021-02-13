# == Schema Information
#
# Table name: webhooks
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  platform   :integer          default("generic")
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint
#
# Indexes
#
#  index_webhooks_on_group_id  (group_id)
#
class Webhook < ApplicationRecord
  belongs_to :group, touch: true

  validates :name, presence: true

  validates :url, presence: true,
                  uniqueness: {
                    scope: :group,
                    message: "Webhook URLs must be unique."
                  }

  enum platform: {
    generic: 0,
    discord: 1,
    vercel: 2,
  }
end
