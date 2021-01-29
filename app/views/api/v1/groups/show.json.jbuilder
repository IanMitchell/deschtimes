json.partial! 'api/v1/groups/group', group: @group, cached: true

json.shows do
  json.partial! 'api/v1/shows/show', collection: @group.shows.visible, as: :show, cached: true
end
