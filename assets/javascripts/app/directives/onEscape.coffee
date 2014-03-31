#global define, require
define ->
  'use strict'

  ###
    Directive that executes an expression when the element it is applied to gets
    an `escape` keydown event.
  ###
  ->
    ESCAPE_KEY = 27
    (scope, elem, attrs) ->
      elem.bind 'keydown', (event) ->
        if event.keyCode == ESCAPE_KEY
          scope.$apply(attrs.todoEscape)
        return
      return
