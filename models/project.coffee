mongoose = require 'mongoose'

ModuleSchema = new mongoose.Schema
  title: String
  name:
    type: String
    unique: true
  tasks: [type: mongoose.Schema.Types.ObjectId, ref: 'Task']

Project = mongoose.model 'Project', new mongoose.Schema
  name:
    type: String
    unique: true
  title: String
  description: String
  type: String
  modules: [ModuleSchema]

module.exports =
  Project: Project
