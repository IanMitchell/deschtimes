json.groups do
  json.partial! 'api/v1/groups/group', collection: @groups, as: :group, cached: true
end
