module.exports = ->
  dashboard:
    query:
      containsText:
        do: (data = {}) ->
          data.query.message = new RegExp "\\b#{data.parameter}\\b", 'i'
          data
      doesNotContainText:
        do: (data = {}) ->
          data.query.message =
            '$not': new RegExp "\\b#{data.parameter}\\b", 'i'
          data
      hasGeo:
        do: (data = {}) ->
          data.query['$or'] = [
            {'location.0': {$gt: 0}}
            {'location.0': {$lt: 0}}
          ]
          data
      isFriend:
        do: (data = {}) ->
          data.query['attributes.isFriend'] = true
          data
      hasPhotoTrue:
        do: (data = {}) ->
          data.query['media.type'] = 'photo'
          data
      hasPhotoFalse:
        do: (data = {}) ->
          data.query['media.type'] =
            $ne: 'photo'
          data
