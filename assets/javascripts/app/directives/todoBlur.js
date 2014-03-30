/*global define, require */
define(function () {
  'use strict';

  /**
   * Directive that executes an expression when the element it is applied to loses focus
   */
  return function () {
    return function (scope, elem, attrs) {
      elem.bind('blur', function () {
        scope.$apply(attrs.todoBlur);
      });
    };
  };
});