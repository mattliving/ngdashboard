mongoose = require 'mongoose'

Task = mongoose.model 'Task', new mongoose.Schema
  name:
    type: String
    unique: true
  title: String
  outcome: String
  howto: String
  resources: [type: mongoose.Schema.Types.ObjectId, ref: 'Resource']

module.exports =
  Task: Task
