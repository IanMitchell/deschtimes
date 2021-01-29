json.id episode.id
json.number episode.number
json.air_date episode.air_date
json.season episode.season
json.released episode.released
json.updated_at episode.updated_at

json.staff do
  json.partial! 'api/v1/staff/staff', collection: episode.staff, as: :staff, cached: true
end
