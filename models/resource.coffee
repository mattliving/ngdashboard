mongoose = require 'mongoose'

Resource = mongoose.model 'Resource', new mongoose.Schema(
  path:
    type: String
    required: true
  topic: [String]
  level:
    type: String
    enum: ['beginner', 'intermediate', 'advanced', 'all']
    required: true
  title:
    type: String
    required: true
  mediaType:
    type: [String]
    enum: []
  description: String
  link:
    type: String
    required: true
  authors: [{}]
  cost: String
)

validateArray = (array) -> array.length > 0

for key in ["mediaType", "authors", "topic"]
  Resource.schema.path(key).validate validateArray, "#{key} must have one or more elements"

module.exports =
  Resource: Resource
