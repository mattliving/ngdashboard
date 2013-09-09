mongoose = require 'mongoose'
{spawn} = require 'child_process'
fs = require 'fs'
cwd = require('path').dirname(require.main.filename)

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

ResourceSchema.post 'save', (doc) ->
  console.log "rendering #{doc.link} to #{doc._id}.png"
  render = spawn 'coffee', ["render.coffee", doc.link, doc._id], cwd: cwd
  render.on 'exit', -> console.log 'done'

ResourceSchema.post 'remove', (doc) ->
  console.log "removing image #{doc._id}.png (#{doc.link})"
  console.log 'cwd: ', cwd
  console.log 'image removal not yet functional'

ResourceModel = mongoose.model 'Resource', ResourceSchema

module.exports =
  Resource: ResourceModel
