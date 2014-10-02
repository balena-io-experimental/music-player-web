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
	playlist = angular.module('playlist', [ 'firebase', 'adaptive.speech' ])

	playlist
		.controller('PlaylistCtrl', playlistCtrl)
		.directive('focusIf', focusIf)
		.directive('onBlur', onBlur)
		.directive('onEscape', onEscape)

	playlist.filter(k, v) for k, v of filters

	return playlist
