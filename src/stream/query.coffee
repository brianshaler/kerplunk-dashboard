_ = require 'lodash'

Fetch = require './fetch'

module.exports = (System) ->
  ActivityItem = System.getModel 'ActivityItem'
  fetch = Fetch System

  (req, res, next) ->
    opt = where: {}

    fetch ActivityItem, opt, (err, activityItems) ->
      if req.params.format == 'json'
        res.send activityItems
      else
        next()
