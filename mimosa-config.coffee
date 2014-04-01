exports.config =
  modules: [
    "copy",
    "bower",
    "server",
    "jshint",
    "csslint",
    "require",
    "minify-js",
    "minify-css",
    "live-reload",
    "coffeescript",
    "sass",
    "server-template-compile",
    "jade-static"
  ]
  bower:
    copy:
      strategy:
        bootstrap: 'none'
      mainOverrides:
        'observe-js': ['src/observe.js']
  require:
    commonConfig: 'require-config'
  minifyJS:
    exclude: [/\.min\./, /app\/.*\.js/]
