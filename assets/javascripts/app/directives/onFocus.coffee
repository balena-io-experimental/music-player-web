#global define, require
define ->
  'use strict'

  ###
    Directive that places focus on the element it is applied to
    when the expression it binds to evaluates to true
  ###
  ($timeout) ->
    (scope, elem, attrs) ->
      scope.$watch attrs.todoFocus, (newVal) ->
        if newVal
          $timeout ->
            elem[0].focus()
          , 0, false
        return
      return
