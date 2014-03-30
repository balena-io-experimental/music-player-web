/*global require, define */
/*jshint unused:false */
define([
	'angular',
	'angular-adaptive-speech',
	'angular-fire'
], function (
	angular
) {
	'use strict';

	/**
	 * The main TodoMVC app module
	 *
	 * @type {angular.Module}
	 */
	var todomvc = angular.module('todomvc', ['firebase', 'adaptive.speech']);

	todomvc.filter('todoFilter', function ($location) {
		return function (input) {
			var filtered = {};
			angular.forEach(input, function (todo, id) {
				var path = $location.path();
				if (path === '/active') {
					if (!todo.completed) {
						filtered[id] = todo;
					}
				} else if (path === '/completed') {
					if (todo.completed) {
						filtered[id] = todo;
					}
				} else {
					filtered[id] = todo;
				}
			});
			return filtered;
		};
	});

	return todomvc;
});