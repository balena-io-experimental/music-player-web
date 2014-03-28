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
    "html-templates",
    "server-template-compile"
  ]
  bower:
    copy:
      strategy: 'none'
