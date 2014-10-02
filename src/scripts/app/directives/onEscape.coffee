define ->
	ESCAPE_KEY = 27

	(scope, elem, attrs) ->
		elem.bind 'keydown', (event) ->
			scope.$apply(attrs.onEscape) if event.keyCode == ESCAPE_KEY

			return
