_ = require 'lodash'

Fetch = require './fetch'

module.exports = (System) ->
  DashboardStream = System.getModel 'DashboardStream'
  ActivityItem = System.getModel 'ActivityItem'
  fetch = Fetch System

  (req, res, next) ->
    DashboardStream.findById req.params.id, (err, stream) ->
      throw err if err
      return next() unless stream

      opt = where: {}
      if req.query?.updatedSince
        opt.where.updatedAt = '$gt': req.query.updatedSince
      if req.query?.postedSince
        opt.where.postedAt = '$gt': req.query.postedSince
      if System.getGlobal('public.streamTypes')[stream.type]?.perUser?
        opt.perUser = System.getGlobal('public.streamTypes')[stream.type].perUser
      #console.log opt
      promises = []
      for condition in stream.conditions
        # console.log "stream.condition: #{condition.name}"
        if conditions = System.getGlobal('public.editStreamConditionOptions')[condition.name]
          if conditions.where
            if typeof conditions.where is 'string'
              promises.push System.do conditions.where,
                query: {}
                parameter: condition.text
            else
              _.extend opt.where, conditions.where

      Promise.all promises
      .then (wheres) ->
        queries = _.compact _.map wheres, 'query'
        for query in queries
          for k, v of query
            if opt.where[k]?
              if opt.where[k]['$and']
                opt.where[k]['$and'].push v
              else
                opt.where[k] =
                  '$and': [
                    opt.where[k]
                    v
                  ]
            else
              opt.where[k] = v
        fetch ActivityItem, opt, (err, activityItems) ->
          res.render 'show',
            data: activityItems
            stream: stream
