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
  playlist = angular.module('playlist', ['firebase', 'adaptive.speech'])

  return playlist
