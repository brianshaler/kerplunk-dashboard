_ = require 'lodash'
Promise = require 'when'

module.exports = (System) ->
  (ActivityItem, _opt, next) ->
    # console.log '_opt', JSON.stringify _opt, null, 2
    opt =
      where: {}
      perUser: 0
      limit: 30

    _.merge opt, _opt
    if opt.perUser == 1 and !opt.where.postedAt?
      opt.where.postedAt =
        "$gt": new Date Date.now() - 1 * 86400 * 1000
    #console.log opt.where
    activityItems = []

    unless opt.where.disliked
      opt.where.disliked = "$ne": true
    unless opt.where.activityOf
      opt.where.activityOf = "$exists": false

    q = ActivityItem.where opt.where
    if opt.perUser != 1
      q = q.limit opt.limit
    q
    .sort postedAt: -1
    .populate 'identity'
    #.populate 'activity'
    .find (err, items) ->
      return next err if err
      return next null, [] unless items?.length > 0
      #activityItems = items
      if opt.perUser == 1
        items = _.uniq items, false, (item) -> item.identity._id
      #console.log _.map items, (item) -> [item.message, item.identity._id]
      Promise.all _.map items, (item) ->
        if item.toObject
          item = item.toObject()
        if item.activity?.length > 0
          item.activity = _.map item.activity, (subItem) ->
            if subItem.toObject
              subItem = subItem.toObject()
            delete subItem.data
            subItem
        item
        System.do 'activityItem.populate', item
        .then ->
          delete item.data if item.data
          delete item.identity.data if item.identity?.data?
          item
      .done (items) ->
        next null, items
      , (err) ->
        next err
