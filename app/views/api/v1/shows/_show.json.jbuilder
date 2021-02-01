json.id show.id
json.name show.name
json.status show.progress_label
json.created_at show.created_at
json.updated_at show.updated_at

if show.poster.attached?
  # Circumvent redirects
  json.poster show.poster.blob.service_url if Rails.env.production?
  json.poster url_for(show.poster) unless Rails.env.production?
else
  json.poster nil
end

json.joint_groups do
  json.partial! 'api/v1/groups/group', collection: show.groups.where.not(id: @group.id), as: :group, cached: true
end

json.episodes do
  json.partial! 'api/v1/episodes/episode', collection: show.episodes, as: :episode, cached: true
end
