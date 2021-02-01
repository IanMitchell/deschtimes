class AddRankToPositions < ActiveRecord::Migration[6.1]
  def change
    add_column :positions, :rank, :integer

    Group.all.each do |group|
      group.positions.each_with_index do |position, index|
        position.update(rank: index)
      end
    end
  end
end
