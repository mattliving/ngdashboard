mongoose = require 'mongoose'

Content = mongoose.model 'Content', new mongoose.Schema
  key: String
  data: {}
,
  collection: 'content'

module.exports =
  Content: Content
