mongoose = require 'mongoose'

Project = mongoose.model 'Project', new mongoose.Schema
  name:
    type: String
    unique: true
  title: String
  description: String
  type: String
  tasks: [type: mongoose.Schema.Types.ObjectId, ref: 'Task']

module.exports =
  Project: Project
