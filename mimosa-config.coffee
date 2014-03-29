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
    "jade"
  ]
  jade:
    static: true
  bower:
    copy:
      strategy: 'none'
  require:
    commonConfig: 'require-config'
  minifyJS:
    exclude: [/\.min\./, /app\/.*\.js/]
