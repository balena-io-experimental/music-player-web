define ['angular'], (angular) ->
  filters = {}
  filters['duration'] = ->
    (input) ->
      input = parseInt input, 10
      if isNaN(input) or input < 0
        return '--:--'
      sec = input % 60
      min = Math.floor input / 60
      sec = (if sec < 10 then '0' else '') + sec
      min = (if min < 10 then '0' else '') + min
      "#{min}:#{sec}"
  return filters