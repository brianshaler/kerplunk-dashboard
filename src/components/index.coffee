React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  render: ->
    DOM.section
      className: 'content'
    ,
      DOM.div null, 'kerplunk-dashboard:index'
