_ = require 'lodash'
React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  getInitialState: ->
    stream: @props.stream ? {_id: 'new'}
    _id: @props.stream?._id ? 'new'
    title: @props.stream?.title ? ''
    type: @props.stream?.type ? 'stream'
    conditions: @props.stream?.conditions ? []

  selectConditionType: (id, e) ->
    console.log 'selectConditionType'
    condition = @state.conditions[id] ? {}
    condition.name = e.target.value
    @state.conditions[id] = condition
    @setState
      conditions: @state.conditions

  selectStreamType: (e) ->
    @setState
      type: e.target.value

  removeCondition: (e) ->
    e.preventDefault()
    id = e.target.getAttribute 'data-id'
    if id == '0'
      id = 0
    else
      id = parseInt id
      unless id > 0
        throw new Error "what's up with this id #{e.target.getAttribute 'data-id'}"
    conditions = @state.conditions
    #conditions.splice id, 1
    conditions[id].deleted = true
    @setState
      conditions: conditions
    console.log 'removeCondition', e.target, e.target.getAttribute 'data-id'

  render: ->
    streamTypes = @props.globals.public.streamTypes ? {}
    conditionOptions = @props.globals.public.editStreamConditionOptions ? {}

    placeholderOption = DOM.option
      key: 'placeholder-option'
      value: ''
    , '-- select --'

    makeCondition = (id = 0, condition = {}) =>
      name = condition?.name
      showText = conditionOptions[name]?.show_text

      DOM.div
        key: "condition-item-#{id}"
        className: 'condition-item edit-stream-condition'
        'data-id': id
      ,
        DOM.select
          name: "stream[conditions][#{id}][name]"
          defaultValue: name
          onChange: (e) =>
            @selectConditionType id, e
        ,
          [placeholderOption].concat _.map conditionOptions, (conditionOption, key) ->
            DOM.option
              key: "condition-option-#{key}"
              value: key
              selected: (true if key == name)
            , conditionOption.description
        DOM.input
          type: 'text'
          className: 'condition-description'
          name: "stream[conditions][#{id}][text]"
          defaultValue: condition.text
          style:
            display: if showText then '' else 'none'
          placeholder: 'e.g. wombats'
        DOM.a
          href: '#'
          className: 'btn btn-xs btn-danger btn-remove'
          onClick: @removeCondition
          'data-id': id
          style:
            display: 'none' if id == @state.conditions.length
        , 'Remove'

    conditions = _.compact _.map @state.conditions, (condition, id) ->
      if condition.deleted != true
        makeCondition id, condition
      else
        null
    conditions.push makeCondition @state.conditions.length

    DOM.section
      className: 'content'
    ,
      DOM.div
        className: 'row'
      ,
        DOM.div
          className: 'col-sm-4'
        ,
          DOM.h2 null, 'Edit Stream'
          DOM.form
            action: "/admin/dashboard/stream/#{@state._id}/edit"
            method: 'post'
          ,
            DOM.input
              type: 'hidden'
              name: 'stream[_id]'
              value: @state._id
            DOM.p null,
              DOM.span null, 'Name: '
              DOM.input
                type: 'text'
                name: 'stream[title]'
                defaultValue: @state.title ? 'wat'
                placeholder: 'e.g. posts about wombats'
              , ''
            DOM.p null,
              DOM.span null, 'Type: '
              DOM.select
                className: 'stream-type'
                name: 'stream[type]'
                value: @state.type
                onChange: @selectStreamType
              ,
                _.map streamTypes, (details, streamType) =>
                  DOM.option
                    key: "streamType-#{streamType}"
                    value: streamType
                    selected: (true if streamType == @state.type)
                  , details.description
            DOM.p null,
              DOM.div null, 'Conditions:'
              DOM.div
                className: 'condition-holder'
              ,
                conditions
            DOM.p
              style:
                textAlign: 'right'
            ,
              DOM.a
                onClick: @props.pushState
                href: "/admin/dashboard/stream/#{@state._id}"
                className: 'btn btn-xs btn-default'
              , 'View Stream'
              DOM.a
                href: "/admin/dashboard/stream/#{@state._id}/delete"
                className: 'btn btn-xs btn-danger'
              , 'Delete'
              DOM.input
                type: 'submit'
                className: 'btn btn-xs btn-success'
                value: 'Save'
