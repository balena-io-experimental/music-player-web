require.config
  paths:
    angular: 'vendor/angular/angular'
    'angular-resource': 'vendor/angular-resource/angular-resource'
    'angular-route': 'vendor/angular-route/angular-route'
    'angular-fire': 'vendor/angularfire/angularfire'
  shim:
    'angular':
      exports: 'angular'
    'angular-resource': ['angular']
    'angular-route': ['angular']
    'angular-fire': ['angular']