module.exports = deleteStream = (System) ->
  DashboardStream = System.getModel 'DashboardStream'

  (req, res, next) ->
    id = req.params.id
    if id
      DashboardStream.findById id, (err, stream) ->
        return next err if err
        return next() unless stream
        stream.remove (err) ->
          return next err if err
          System.reset()
          .then ->
            res.redirect '/admin/dashboard'
