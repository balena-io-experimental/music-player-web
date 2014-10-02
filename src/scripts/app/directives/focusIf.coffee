define -> ($timeout) ->
	(scope, elem, attrs) ->
        scope.$watch attrs.focusIf, (newVal) ->
            if newVal
                $timeout ->
                    elem[0].focus()
                , 0, false
            return
