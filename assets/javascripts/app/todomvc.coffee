#global require, define
#jshint unused:false
define [
  'angular',
  'angular-adaptive-speech',
  'angular-fire'
], (angular) ->
  'use strict'

  ###
    The main TodoMVC app module

    @type {angular.Module}
  ###
  todomvc = angular.module('todomvc', ['firebase', 'adaptive.speech'])

  todomvc.filter 'todoFilter', ($location) ->
    (input) ->
      filtered = {}
      angular.forEach input, (todo, id) ->
        path = $location.path()
        if path == '/active'
          if not todo.completed
            filtered[id] = todo
        else if path == '/completed'
          if todo.completed
            filtered[id] = todo
        else
          filtered[id] = todo
      return filtered

  return todomvc
