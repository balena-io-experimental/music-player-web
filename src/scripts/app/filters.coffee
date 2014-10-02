define [ 'angular' ], (angular) ->
	filters = {}
	filters.duration = -> (input) ->
		input = parseInt(input, 10)

		return '--:--' if isNaN(input) or input < 0

		sec = input % 60
		min = Math.floor input / 60
		sec = (if sec < 10 then '0' else '') + sec
		min = (if min < 10 then '0' else '') + min

		return "#{min}:#{sec}"

	return filters
