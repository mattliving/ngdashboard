mongoose = require 'mongoose'

ResourceSchema = new mongoose.Schema
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
  description: String
  link:
    type: String
    required: true
  authors: [{}]
  cost: String

ResourceSchema.post 'save', (doc) ->
  console.log "this would now render #{doc.link} to #{doc._id}.png"

ResourceModel = mongoose.model 'Resource', ResourceSchema

validateArray = (array) -> array.length > 0

for key in ["mediaType", "authors", "topic"]
  ResourceModel.schema.path(key).validate validateArray, "#{key} must have one or more elements"

module.exports =
  Resource: ResourceModel
