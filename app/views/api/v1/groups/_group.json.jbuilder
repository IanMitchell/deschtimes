json.id group.id
json.name group.name
json.acronym group.acronym

if group.icon.attached?
  # Circumvent redirects
  json.icon group.icon.blob.url if Rails.env.production?
  json.icon url_for(group.icon) unless Rails.env.production?
else
  json.icon nil
end
