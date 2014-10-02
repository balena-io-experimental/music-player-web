define -> ->
    return (scope, elem, attrs) ->
        elem.bind 'blur', ->
            scope.$apply(attrs.onBlur)

            return
