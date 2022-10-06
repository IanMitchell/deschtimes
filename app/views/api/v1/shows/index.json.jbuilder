json.shows @group.shows.visible do |show|
  json.id show.id
  json.name show.name
  json.status show.status

  json.terms show.terms do |term|
    json.name term.name
  end
end
