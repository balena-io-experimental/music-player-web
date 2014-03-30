window.name = "NG_DEFER_BOOTSTRAP!"

require ['require-config'], ->
  require ['angular', 'app'], (angular) ->
    angular.element(document).ready ->
      angular.resumeBootstrap()
