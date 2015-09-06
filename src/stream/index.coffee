Edit = require './edit'
Show = require './show'
All = require './all'
Query = require './query'

module.exports = (System) ->
  edit: Edit System
  show: Show System
  all: All System
  query: Query System
