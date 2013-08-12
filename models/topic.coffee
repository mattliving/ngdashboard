mongoose = require 'mongoose'

Topic = mongoose.model 'Topic', new mongoose.Schema(
  id: String
  description: 
    what: String
    why: String
  dependancies: [{}]
)

module.exports = 
  Topic: Topic