_ = require 'lodash'
React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  render: ->
    DOM.section
      className: 'content'
    ,
      _.map @props.streams, (stream) =>
        DOM.div
          key: stream._id
        ,
          DOM.h3 null, stream.title
          DOM.a
            onClick: @props.pushState
            href: "/admin/dashboard/stream/#{stream._id}/edit"
          , '[edit]'
