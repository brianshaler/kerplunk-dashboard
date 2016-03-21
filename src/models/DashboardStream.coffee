###
# DashboardStream schema
###

#mongoose = require "mongoose"
#Schema = mongoose.Schema

module.exports = (mongoose) ->
  Schema = mongoose.Schema
  ObjectId = Schema.ObjectId
  DashboardStreamSchema = new Schema
    title:
      type: String
      default: ''
    type:
      type: String
      default: 'stream'
    conditions: [{}]
    attributes: {}
    createdAt:
      type: Date
      default: Date.now

  DashboardStreamSchema.pre 'save', (next) ->
    @markModified 'conditions'
    @markModified 'attributes'
    next()

  mongoose.model 'DashboardStream', DashboardStreamSchema
