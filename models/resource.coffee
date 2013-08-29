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
  title:
    type: String
    required: true
  mediaType:
    type: [String]
  resourceType: String
  description: String
  link:
    type: String
    required: true
  authors: [{}]
  cost:
    type: String
    default: "free"
  unfinished: Boolean

ResourceSchema.pre 'save', (next) ->
  arraysDone = @topic? and @topic > 0 and @mediaType? and @mediaType.length > 0
  textDone = @title? and @resourceType? and @level?
  @unfinished = not (arraysDone and textDone)
  next()


ResourceSchema.post 'save', (doc) ->
  console.log "(not) rendering #{doc.link} to #{doc._id}.png"
  # render = spawn 'coffee', ["render.coffee", doc.link, doc._id], cwd: require('path').dirname(require.main.filename)
  # render.stdout.on 'data', (data) -> console.log data.toString()

ResourceModel = mongoose.model 'Resource', ResourceSchema

module.exports =
  Resource: ResourceModel
