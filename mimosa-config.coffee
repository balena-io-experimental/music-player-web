exports.config =
	modules: [
		'copy'
		'bower'
		'server'
		'jshint'
		'csslint'
		'require'
		'minify-js'
		'minify-css'
		'live-reload'
		'coffeescript'
		'sass'
		'server-template-compile'
		'jade-static'
	]
	watch:
		sourceDir: 'src'
		javascriptDir: 'scripts'
	vendor:
		javascripts: 'scripts/vendor'
		stylesheets: 'stylesheets/vendor'
	server:
		views:
			path: 'src/views'
	liveReload:
		additionalDirs: []
	template:
		outputFileName: 'scripts/templates'

	bower:
		copy:
			strategy:
				bootstrap: 'none'
			mainOverrides:
				'observe-js': [ 'src/observe.js' ]
	require:
		commonConfig: 'require-config'
	minifyJS:
		exclude: [ /\.min\./, /app\/.*\.js/ ]
