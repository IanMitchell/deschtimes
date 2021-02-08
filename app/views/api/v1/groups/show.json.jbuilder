json.partial! 'api/v1/groups/group', group: @group, cached: true

json.shows do
  json.partial! 'api/v1/shows/show', collection: @group.shows.with_attached_poster.visible.where(projects: { group: @group, status: :accepted }), as: :show, cached: true
end
