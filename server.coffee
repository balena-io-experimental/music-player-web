engines = require 'consolidate'
express = require 'express'

exports.startServer = (config, callback) ->

	port = process.env.PORT or config.server.port

	app = express()
	server = app.listen port, ->
		console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env

	app.configure ->
		app.set('port', port)
		app.set('views', config.server.views.path)
		app.engine(config.server.views.extension, engines[config.server.views.compileWith])
		app.set('view engine', config.server.views.extension)
		app.use(express.favicon())
		app.use(express.urlencoded())
		app.use(express.json())
		app.use(express.methodOverride())
		app.use(express.compress())
		app.use(config.server.base, app.router)
		app.use(express.static(config.watch.compiledDir))

		app.locals.pretty = true

	app.configure 'development', ->
		app.use(express.errorHandler())

	app.get '/', (req, res) ->
		production = process.env.NODE_ENV is 'production'

		# In the event plain html pages are being used, need to
		# switch to different page for optimized view
		name = if config.isOptimize and config.server.views.html
			"index-optimize"
		else
			"index"

		now = new Date().getTime()

		res.render name,
			reload: config.liveReload.enabled
			optimize: config.isOptimize ? false
			cachebust: if !production then "?b=#{now}" else ''


	callback(server)
