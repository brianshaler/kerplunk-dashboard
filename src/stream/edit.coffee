_ = require 'lodash'

module.exports = editStream = (System) ->
  DashboardStream = System.getModel 'DashboardStream'

  (req, res, next) ->
    id = req.params.id

    show = (stream = {}) ->
      console.log 'show stream', stream._id
      res.render 'edit',
        stream: stream

    updateStream = (stream = new DashboardStream(), props, _next) ->
      resetRequired = false
      if stream.title != props.title
        console.log 'title has changed', props.title
        stream.title = props.title
        resetRequired = true
        #process.emit "reset"
      stream.type = props.type
      stream.conditions = []
      stream.attributes = props.attributes ? {}

      conditions = _.filter props.conditions, (condition) ->
        condition?.name?.length > 0
      _.each conditions, (condition) -> stream.conditions.push condition

      stream.save (err) ->
        if resetRequired
          System.reset()
          .then ->
            _next stream
        else
          _next stream

    if (!id or id == 'new') and req.body?.stream?._id == "new"
      updateStream null, req.body?.stream, (stream) ->
        res.redirect "/admin/dashboard/stream/#{stream._id}/edit"
    else if id and id != 'new'
      DashboardStream.findById id, (err, stream) ->
        throw err if err
        console.log "NOT FOUND #{id}" unless stream
        return next() unless stream

        if req.body?.stream?._id
          # update and then show
          updateStream stream, req.body.stream, ((stream) -> show stream)
        else
          # just show
          show stream
    else
      # show blank
      show()
