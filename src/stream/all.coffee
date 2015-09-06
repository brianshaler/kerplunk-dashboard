_ = require 'lodash'

Fetch = require './fetch'

module.exports = (System) ->
  DashboardStream = System.getModel 'DashboardStream'
  ActivityItem = System.getModel 'ActivityItem'

  fetch = Fetch System

  (req, res, next) ->
    stream =
      _id: 'all'
      title: 'All Posts'

    fetch ActivityItem, {}, (err, activityItems) ->
      res.render 'show',
        data: activityItems
        stream: stream
