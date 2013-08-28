mongoose = require 'mongoose'
# {spawn} = require('child_process')

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
  console.log "(not) rendering #{doc.link} to #{doc._id}.png"
  # render = spawn 'coffee', ["render.coffee", doc.link, doc._id], cwd: require('path').dirname(require.main.filename)
  # render.stdout.on 'data', (data) -> console.log data.toString()

ResourceModel = mongoose.model 'Resource', ResourceSchema

validateArray = (array) -> array.length > 0

for key in ["mediaType", "authors", "topic"]
  ResourceModel.schema.path(key).validate validateArray, "#{key} must have one or more elements"

module.exports =
  Resource: ResourceModel
