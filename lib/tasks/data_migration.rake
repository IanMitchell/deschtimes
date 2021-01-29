require 'csv'

namespace :data_migration do
  task :import => :environment do
    # Import Users
    user_map = {}
    puts "Migrating Users..."
    CSV.foreach("#{Rails.root}/lib/assets/data/administrators.csv", headers: true, header_converters: :symbol) do |row|
      user = User.create(
        name: row[:name],
        email: row[:email],
        password: 'password',
        created_at: row[:created_at],
        updated_at: row[:updated_at],
      )

      user_map[row[:id]] = user.id
    end

    # Import Groups
    group_map = {}
    puts "Migrating Groups..."
    CSV.foreach("#{Rails.root}/lib/assets/data/groups.csv", headers: true, header_converters: :symbol) do |row|
      group = Group.create(
        name: row[:name],
        acronym: row[:acronym],
        created_at: row[:created_at],
        updated_at: row[:updated_at],
      )

      Webhook.create(
        name: "Discord Progress",
        url: row[:webhook],
        platform: :discord,
        group: group,
        created_at: row[:created_at],
        updated_at: row[:updated_at],
      )

      group_map[row[:id]] = group.id
    end

    # Create Authorized Users.
    puts "Migrating Authorized Users... remember to manually edit the Owner!"
    CSV.foreach("#{Rails.root}/lib/assets/data/administrators_groups.csv", headers: true, header_converters: :symbol) do |row|
      AuthorizedUser.create(
        group_id: group_map[row[:group_id]],
        user_id: user_map[row[:administrator_id]],
        created_at: row[:created_at],
        updated_at: row[:updated_at],
      )
    end

    # Create Members
    member_map = {}
    puts "Migrating Members..."
    CSV.foreach("#{Rails.root}/lib/assets/data/members.csv", headers: true, header_converters: :symbol) do |row|
      member = Member.create(
        name: row[:name],
        discord: row[:discord],
        group_id: group_map[row[:group_id]],
        admin: row[:admin],
        created_at: row[:created_at],
        updated_at: row[:updated_at],
      )

      member_map[row[:id]] = member.id
    end

    # Import Shows
    show_map = {}
    puts "Migrating Shows..."
    Show.skip_callback(:create, :after, :create_episodes)
    CSV.foreach("#{Rails.root}/lib/assets/data/fansubs.csv", headers: true, header_converters: :symbol) do |row|
      show = Show.create(
        name: row[:name],
        visible: row[:visible],
        created_at: row[:created_at],
        updated_at: row[:updated_at],
      )

      show_map[row[:id]] = show.id
    end

    # Import Projects
    puts "Migrating Projects..."
    CSV.foreach("#{Rails.root}/lib/assets/data/group_fansubs.csv", headers: true, header_converters: :symbol) do |row|
      Project.create(
        show_id: show_map[row[:fansub_id]],
        group_id: group_map[row[:group_id]],
        status: :accepted,
        created_at: row[:created_at],
        updated_at: row[:updated_at],
      )
    end

    # Import Terms
    puts "Migrating Terms..."
    CSV.foreach("#{Rails.root}/lib/assets/data/terms.csv", headers: true, header_converters: :symbol) do |row|
      Term.create(
        show_id: show_map[row[:fansub_id]],
        name: row[:name],
        created_at: row[:created_at],
        updated_at: row[:updated_at],
      )
    end

    # Import Episodes
    episode_map = {}
    puts "Migrating Episodes..."
    CSV.foreach("#{Rails.root}/lib/assets/data/releases.csv", headers: true, header_converters: :symbol) do |row|
      episode = Episode.create(
        show_id: show_map[row[:fansub_id]],
        air_date: row[:air_date],
        number: row[:number],
        released: row[:released],
        created_at: row[:created_at],
        updated_at: row[:updated_at],
      )

      episode_map[row[:id]] = episode.id
    end

    # Import Staff
    puts "Migrating Staff..."
    old_positions = {
      1 => "Translator",
      2 => "Translator Check",
      3 => "Encoder",
      4 => "Editor",
      5 => "Timer",
      6 => "Typesetter",
      7 => "Quality Control"
    }

    CSV.foreach("#{Rails.root}/lib/assets/data/staff.csv", headers: true, header_converters: :symbol) do |row|
      next if row[:member_id] == "185"
      if member_map[row[:member_id]].nil?
        puts "Staff: #{row[:id]}, Member: #{row[:member_id]}, Release: #{row[:release_id]}"
      end

      member = Member.find(member_map[row[:member_id]])
      position = Position.find_by(
        group: member.group,
        name: old_positions[row[:position_id]]
      )

      Staff.create(
        member: member,
        position: position,
        episode_id: episode_map[row[:release_id]],
        finished: row[:finished],
        created_at: row[:created_at],
        updated_at: row[:updated_at],
      )
    end
  end
end
