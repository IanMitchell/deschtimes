# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  acronym    :string           not null
#  name       :string           not null
#  slug       :string
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_groups_on_acronym  (acronym) UNIQUE
#  index_groups_on_name     (name) UNIQUE
#  index_groups_on_slug     (slug) UNIQUE
#  index_groups_on_token    (token) UNIQUE
#
require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "search prioritizes exact term match" do
    show = Group.find_by(name: 'Cartel').priority_show_search!("exact")
    assert_equal "Fuzzy Find Show", show.name
  end

  test "search handles single match" do
    show = Group.find_by(name: 'Cartel').priority_show_search!("multiple")
    assert_equal "Fuzzy Find Show Multiple", show.name
  end

  test "search prioritizes airing shows" do
    show = Group.find_by(name: 'Cartel').priority_show_search!("CommonSearchTerm")
    assert_equal "Airing Show CommonSearchTerm", show.name
  end

  test "search prioritizes active shows" do
    episodes = Show.find_by(name: 'Airing Show CommonSearchTerm').episodes
    episodes.each do |episode|
      episode.update(released: true, air_date: episode.air_date - 1.year)
    end

    show = Group.find_by(name: 'Cartel').priority_show_search!("CommonSearchTerm")
    assert_equal "Active Show CommonSearchTerm", show.name
  end

  test "search handles multiple shows" do
    assert_raises MultipleMatchingShowsError do
      show = Group.find_by(name: 'Cartel').priority_show_search!("fuzzy")
    end
  end

  test "search does not match invisible shows" do
    assert_raises ShowNotFoundError do
      Group.find_by(name: 'Cartel').priority_show_search!("secret")
    end
  end

  test "search does not match term unassociated with group" do
    Show.find_by(name: 'Trinity Show').update(name: 'Public Trinity Show')
    show = Group.find_by(name: 'Trinity').priority_show_search!("public")
    assert_equal "Public Trinity Show", show.name
  end
end
