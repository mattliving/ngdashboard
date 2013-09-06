mongoose = require 'mongoose'
{spawn} = require 'child_process'

ResourceSchema = new mongoose.Schema
  title:
    type: String
    required: true
  mediaType:
    type: [String]
  topic: [String]
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
  textDone = @title? and @resourceType?
  @unfinished = not (arraysDone and textDone)
  next()

ResourceSchema.post 'save', (doc) ->
  console.log "rendering #{doc.link} to #{doc._id}.png"
  render = spawn 'coffee', ["render.coffee", doc.link, doc._id], cwd: require('path').dirname(require.main.filename)
  render.on 'exit', -> console.log 'done'

ResourceModel = mongoose.model 'Resource', ResourceSchema

module.exports =
  Resource: ResourceModel
