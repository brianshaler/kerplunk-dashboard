_ = require 'lodash'

DashboardStreamSchema = require './models/DashboardStream'

Stream = require './stream'
Events = require './events'

module.exports = (System) ->
  DashboardStream = System.registerModel 'DashboardStream', DashboardStreamSchema
  StreamAPI = Stream System

  index = (req, res, next) ->
    DashboardStream.find {}, (err, streams) ->
      res.render 'index',
        streams: streams

  index = (req, res, next) ->
    DashboardStream
    .where {}
    .find (err, streams) ->
      res.render 'index',
        streams: streams

  settings = (req, res, next) ->
    DashboardStream
    .where {}
    .find (err, streams) ->
      return next err if err
      res.render 'settings',
        streams: streams

  deleteStream = (req, res, next) ->
    return next() unless req.params.id
    DashboardStream
    .where
      _id: req.params.id
    .remove (err) ->
      return next err if err
      System.reset()
      .then ->
        res.redirect '/admin/dashboard/settings'

  Dashboard =
    routes:
      admin:
        '/admin/dashboard/stream/create': 'edit'
        '/admin/dashboard/stream/all': 'all'
        '/admin/dashboard/stream/:id': 'show'
        '/admin/dashboard/stream/:id/edit': 'edit'
        '/admin/dashboard/stream/:id/delete': 'delete'
        '/admin/dashboard/stream': 'all'
        '/admin/dashboard/settings': 'settings'
        '/admin/dashboard': 'index'

    handlers:
      all: StreamAPI.all
      edit: StreamAPI.edit
      show: StreamAPI.show
      delete: deleteStream
      index: index
      settings: settings

    globals:
      public:
        nav: {}
        css:
          'kerplunk-dashboard:edit': 'kerplunk-dashboard/css/edit.css'
        editStreamConditionOptions:
          containsText:
            description: 'contains the text..'
            show_text: true
            where: 'dashboard.query.containsText'
          doesNotContainText:
            description: 'does not contain the text..'
            show_text: true
            where: 'dashboard.query.doesNotContainText'
          hasPhotoTrue:
            description: 'has photo'
            where: 'dashboard.query.hasPhotoTrue'
          hasPhotoFalse:
            description: 'does not have photo'
            where: 'dashboard.query.hasPhotoFalse'
          hasGeo:
            description: 'is geotagged'
            where: 'dashboard.query.hasGeo'
          friendsOnly:
            description: 'friends only'
            where: 'dashboard.query.isFriend'

    events: Events()

    init: (next) ->
      DashboardStream.find {}, (err, streams) ->
        nav =
          Admin:
            Dashboard:
              Settings: '/admin/dashboard/settings'
          Dashboard: {}
        #  'All Items': '/admin/dashboard'
        if !err and streams?.length > 0
          for stream in streams
            nav.Dashboard[stream.title] = "/admin/dashboard/stream/#{stream._id}"
            nav.Admin.Dashboard[stream.title] = "/admin/dashboard/stream/#{stream._id}/edit"
        nav.Admin.Dashboard['New Stream'] = '/admin/dashboard/stream/create'
        nav.Dashboard['All Posts'] = '/admin/dashboard/stream'
        Dashboard.globals.public.nav = nav
        next()
