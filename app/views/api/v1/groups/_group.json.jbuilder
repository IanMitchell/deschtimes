json.id group.id
json.name group.name
json.acronym group.acronym
json.icon group.icon.attached? ? url_for(group.icon) : nil
