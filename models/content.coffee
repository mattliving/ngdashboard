mongoose = require 'mongoose'

Content = mongoose.model 'Content', new mongoose.Schema
  key: String
  data: mongoose.Schema.Types.Mixed
,
  collection: 'content'

module.exports =
  Content: Content
