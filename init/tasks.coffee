# Available tasks prefixed with config.rb.prefix.task.
# Order doesn't matter besides:
# browser-sync must run before nodemon and watch when in dev mode.
# ================================================================
module.exports = (gulp, config) ->
	# browser
	# =======
	bs = require("#{config.req.tasks}/browser/browser-sync")        gulp, config     # browser-sync
	require("#{config.req.tasks}/browser/open-browser")             gulp, config     # open-browser

	# build
	# =====
	require("#{config.req.tasks}/build/build-angular-modules")      gulp, config     # build-angular-modules
	require("#{config.req.tasks}/build/build-bower-json")           gulp, config     # build-bower-json
	require("#{config.req.tasks}/build/build-config")               gulp, config     # build-config
	require("#{config.req.tasks}/build/build-files")                gulp, config     # build-files
	require("#{config.req.tasks}/build/build-files-prod")           gulp, config     # build-files-prod
	require("#{config.req.tasks}/build/build-spa")                  gulp, config     # build-spa

	# clean
	# =====
	require("#{config.req.tasks}/clean/clean-config")               gulp, config     # clean-config
	require("#{config.req.tasks}/clean/clean-dist")                 gulp, config     # clean-dist
	require("#{config.req.tasks}/clean/clean-files")                gulp, config     # clean-files
	require("#{config.req.tasks}/clean/cleanup-client")             gulp, config     # cleanup-client

	# common
	# =======
	require("#{config.req.tasks}/common")                           gulp, config     # common

	# compile
	# =======
	require("#{config.req.tasks}/compile/coffee")                   gulp, config     # coffee
	require("#{config.req.tasks}/compile/es6")                      gulp, config     # es6
	require("#{config.req.tasks}/compile/less")                     gulp, config     # less

	# copy
	# ====
	require("#{config.req.tasks}/copy/copy-bower_components")       gulp, config     # copy-bower_components
	require("#{config.req.tasks}/copy/copy-css")                    gulp, config     # copy-css
	require("#{config.req.tasks}/copy/copy-html")                   gulp, config     # copy-html
	require("#{config.req.tasks}/copy/copy-images")                 gulp, config     # copy-images
	require("#{config.req.tasks}/copy/copy-js")                     gulp, config     # copy-js
	require("#{config.req.tasks}/copy/copy-libs")                   gulp, config     # copy-libs
	require("#{config.req.tasks}/copy/copy-server-config")          gulp, config     # copy-server-config
	require("#{config.req.tasks}/copy/copy-server-node_modules")    gulp, config     # copy-server-node_modules
	require("#{config.req.tasks}/copy/copy-views")                  gulp, config     # copy-views

	# manage
	# ======
	require("#{config.req.tasks}/manage/bower")                     gulp, config     # bower

	# minify
	# ======
	require("#{config.req.tasks}/minify/concat-scripts-and-styles") gulp, config     # concat-scripts-and-styles
	require("#{config.req.tasks}/minify/minify-client")             gulp, config     # minify-client
	require("#{config.req.tasks}/minify/minify-css")                gulp, config     # minify-css
	require("#{config.req.tasks}/minify/minify-html")               gulp, config     # minify-html
	require("#{config.req.tasks}/minify/minify-images")             gulp, config     # minify-images
	require("#{config.req.tasks}/minify/minify-js")                 gulp, config     # minify-js
	require("#{config.req.tasks}/minify/minify-server")             gulp, config     # minify-server
	require("#{config.req.tasks}/minify/minify-spa")                gulp, config     # minify-spa
	require("#{config.req.tasks}/minify/template-cache")            gulp, config     # template-cache

	# server
	# ======
	require("#{config.req.tasks}/server/start-server")              gulp, config     # start-server
	require("#{config.req.tasks}/server/nodemon")                   gulp, config, bs # nodemon

	# watch
	# =====
	require("#{config.req.tasks}/watch/watch")                      gulp, config, bs # watch
	require("#{config.req.tasks}/watch/watch-build-spa")            gulp, config     # watch-build-spa


