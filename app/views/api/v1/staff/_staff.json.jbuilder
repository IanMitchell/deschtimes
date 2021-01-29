json.id staff.id
json.finished staff.finished
json.updated_at staff.updated_at

json.position do
  json.id staff.position.id
  json.name staff.position.name
  json.acronym staff.position.acronym
end

json.member do
  json.id staff.member.id
  json.name staff.member.name
  json.group staff.member.group.id
end
