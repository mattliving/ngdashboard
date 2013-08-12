{Resource} = require('../models/resource')
{Topic}    = require('../models/topic')

module.exports =
  site:
    index: (req, res) ->
    # res.sendfile path.resolve(__dirname + req.url)

    paths: (req, res) ->

    topics: (req, res) ->
      Topic.find {}, (err, topics) ->
        unless err
          res.json topics
        else console.log err

    topicsByName: (req, res) ->
      Topic.find {}, {_id: 0, name: 1}, (err, topics) ->
        unless err
          res.json topics
        else console.log err

    topicDependancies: (req, res) ->
      Topic.find {}, {_id: 0, dependancies: 1}, (err, topics) ->
        unless err
          res.json topics
        else console.log err

  resources:
    all: (req, res) ->
      Resource.find().exec (err, resources) ->
        unless err
          res.json resources
        else
          console.log err
          res.json error: err

    add: (req, res) ->
      # console.log req.body
      resource = new Resource
        authors: req.body.authors
        topic: req.body.topic
        mediaType: req.body.mediaType
        title: req.body.title
        link: req.body.link
        level: req.body.level
        path: req.body.path
        cost: req.body.cost
        description: req.body.description
      resource.save (err) ->
        # console.log if err then err else 'saved successfully'
        if err?
          console.log err
          res.status 400
          res.send err
        else
          console.log 'saved'
          res.json _id: resource._id

    delete: (req, res) ->
      Resource.remove _id: req.params.id, (err) ->
        if err
          res.status 400
          err.success = false
          res.json err
        else
          res.json success: true

    path: (req, res) ->
      Resource.find()
      .where('path', req.params.path).exec (err, resources) ->
        unless err
          res.json resources
        else console.log err

    topic: (req, res) ->
      Resource.find()
      .where('path', req.params.path)
      .where('topic').in([req.params.topic]).exec (err, resources) ->
        unless err
          res.json resources
        else console.log err

    level: (req, res) ->
      Resource.find()
      .where('path', req.params.path)
      .where('topic').in([req.params.topic])
      .where('level', req.params.level).exec (err, resources) ->
        unless err
          res.json resources
        else console.log err

    type: (req, res) ->
      Resource.find()
      .where('path', req.params.path)
      .where('topic').in([req.params.topic])
      .where('mediaType').in([req.params.type])
      .exec (err, resources) ->
        unless err
          res.json resources
        else console.log err

    typeAndLevel: (req, res) ->
      Resource.find()
      .where('path', req.params.path)
      .where('topic').in([req.params.topic])
      .where('mediaType').in([req.params.type])
      .where('level', req.params.level)
      .exec (err, resources) ->
        unless err
          res.json resources
        else console.log err
