mongoose = require 'mongoose'

Type = mongoose.model 'Type', new mongoose.Schema
  type: String
  key: String
  value: String

module.exports =
  Type: Type
