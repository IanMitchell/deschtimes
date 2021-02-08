json.partial! 'api/v1/groups/group', group: @group, cached: true

json.shows do
  json.partial! 'api/v1/shows/show', collection: @group.shows.with_attached_poster.includes(episodes: [staff: [:position, member: [:group]]]).visible, as: :show, cached: true
end
