_ = require 'lodash'
React = require 'react'
ReactiveData = require 'reactive-data'

{DOM} = React

module.exports = React.createFactory React.createClass
  getInitialState: ->
    streamTypes = @props.globals.public.streamTypes
    streamComponent = @props.stream.type
    unless streamTypes[streamComponent]
      streamComponent = Object.keys(streamTypes)?[0]
    streamInfo = streamTypes[streamComponent]
    # console.log 'initial state:',
    #   streamComponent: streamComponent
    #   streamInfo: streamInfo
    #   propsStream: @props.stream

    streamComponent: streamComponent
    streamInfo: streamInfo

  render: ->
    Component = @props.getComponent @state.streamComponent
    if !Component
      console.log 'no component?', @state.streamComponent, @props.stream.type
      console.log Object.keys @props.globals.public.streamTypes
      console.log Object.keys @props.components

    DOM.div
      style:
        minHeight: '100%'
    ,
      DOM.div null, "show stream: #{@props.stream.title}"
      if @props.stream._id != 'all'
        DOM.a
          onClick: @props.pushState
          href: "/admin/dashboard/stream/#{@props.stream._id}/edit"
        , 'edit this stream'
      else
        null
      Component _.extend {}, @props, @state, {key: @props.stream._id}
