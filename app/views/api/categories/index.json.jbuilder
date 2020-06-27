json.choices do
  json.array! @categories, :id, :name
end