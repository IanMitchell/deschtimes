json.id show.id
json.name show.name
json.status show.progress_label
json.created_at show.created_at
json.updated_at show.updated_at
json.poster if show.poster.attached? ? show.poster.blob.service_url : nil

json.joint_groups do
  json.partial! 'api/v1/groups/group', collection: show.groups.where.not(id: @group.id), as: :group, cached: true
end

json.episodes do
  json.partial! 'api/v1/episodes/episode', collection: show.episodes, as: :episode, cached: true
end
