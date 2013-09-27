mongoose = require 'mongoose'

ModuleSchema = new mongoose.Schema
  name:
    type: String
    unique: true
  title: String
  tasks: [type: mongoose.Schema.Types.ObjectId, ref: 'Task']

Project = mongoose.model 'Project', new mongoose.Schema
  name:
    type: String
    unique: true
  title: String
  subtitle: String
  overview: String
  modules: [ModuleSchema]

module.exports =
  Project: Project
