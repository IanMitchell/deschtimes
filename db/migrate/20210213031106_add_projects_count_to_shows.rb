class AddProjectsCountToShows < ActiveRecord::Migration[6.1]
  def change
    add_column :shows, :projects_count, :integer, default: 0, null: false

    Show.find_each { |show| Show.reset_counters(show.id, :projects) }
  end
end
