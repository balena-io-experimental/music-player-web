#global define, require
define ->
	'use strict'

	###
		Directive that executes an expression when
		the element it is applied to loses focus
	###
	->
		(scope, elem, attrs) ->
			elem.bind 'blur', ->
				scope.$apply(attrs.onBlur)
			return
