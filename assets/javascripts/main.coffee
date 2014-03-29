window.name = "NG_DEFER_BOOTSTRAP!"

require ['require-config'], ->
  require ['angular', 'app/project'], (angular) ->
    angular.element().ready ->
      angular.resumeBootstrap(['project'])
