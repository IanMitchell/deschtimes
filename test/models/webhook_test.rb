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
require 'test_helper'

class WebhookTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
