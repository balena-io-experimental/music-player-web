#global require, define
#jshint unused:false
define [
	'angular',
	'c/playlistCtrl',
	'd/focusIf',
	'd/onBlur',
	'd/onEscape',
	'./filters'
	'angular-adaptive-speech',
	'angular-fire',
], (angular, playlistCtrl, focusIf, onBlur, onEscape, filters) ->
	'use strict'

	###
		The main TodoMVC app module

		@type {angular.Module}
	###
	playlist = angular.module('playlist', ['firebase', 'adaptive.speech'])
	playlist
		.controller 'PlaylistCtrl', playlistCtrl
		.directive 'focusIf', focusIf
		.directive 'onBlur', onBlur
		.directive 'onEscape', onEscape
	for k, v of filters
		playlist.filter k, v

	return playlist
