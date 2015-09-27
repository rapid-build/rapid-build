# Available tasks prefixed with config.rb.prefix.task.
# Order doesn't matter besides:
# browser-sync must run before nodemon and watch when in dev mode.
# ================================================================
module.exports = (gulp, config) ->
	# browser
	# =======
	bs = require("#{config.req.tasks}/browser/browser-sync")        gulp, config
	require("#{config.req.tasks}/browser/open-browser")             gulp, config

	# build
	# =====
	require("#{config.req.tasks}/build/build-angular-modules")      gulp, config
	require("#{config.req.tasks}/build/build-bower-json")           gulp, config
	require("#{config.req.tasks}/build/build-config")               gulp, config
	require("#{config.req.tasks}/build/build-files")                gulp, config
	require("#{config.req.tasks}/build/build-prod-files")           gulp, config
	require("#{config.req.tasks}/build/build-prod-files-blueprint") gulp, config
	require("#{config.req.tasks}/build/build-spa")                  gulp, config

	# clean
	# =====
	require("#{config.req.tasks}/clean/clean-config")               gulp, config
	require("#{config.req.tasks}/clean/clean-dist")                 gulp, config
	require("#{config.req.tasks}/clean/clean-files")                gulp, config
	require("#{config.req.tasks}/clean/cleanup-client")             gulp, config

	# common
	# ======
	require("#{config.req.tasks}/common/common")                    gulp, config
	require("#{config.req.tasks}/common/common-client")             gulp, config
	require("#{config.req.tasks}/common/common-server")             gulp, config
	require("#{config.req.tasks}/common/common-test-client")        gulp, config
	require("#{config.req.tasks}/common/common-test-server")        gulp, config

	# compile
	# =======
	require("#{config.req.tasks}/compile/coffee")                   gulp, config
	require("#{config.req.tasks}/compile/es6")                      gulp, config
	require("#{config.req.tasks}/compile/less")                     gulp, config
	require("#{config.req.tasks}/compile/sass")                     gulp, config

	# config
	# ======
	require("#{config.req.tasks}/config/set-env-config")              gulp, config
	require("#{config.req.tasks}/config/update-angular-mocks-config") gulp, config

	# copy
	# ====
	require("#{config.req.tasks}/copy/copy-bower_components")       gulp, config
	require("#{config.req.tasks}/copy/copy-css")                    gulp, config
	require("#{config.req.tasks}/copy/copy-html")                   gulp, config
	require("#{config.req.tasks}/copy/copy-images")                 gulp, config
	require("#{config.req.tasks}/copy/copy-js")                     gulp, config
	require("#{config.req.tasks}/copy/copy-libs")                   gulp, config
	require("#{config.req.tasks}/copy/copy-server-config")          gulp, config
	require("#{config.req.tasks}/copy/copy-server-node_modules")    gulp, config
	require("#{config.req.tasks}/copy/copy-views")                  gulp, config

	# extra
	# =====
	require("#{config.req.tasks}/extra/compile-extra-coffee")       gulp, config
	require("#{config.req.tasks}/extra/compile-extra-es6")          gulp, config
	require("#{config.req.tasks}/extra/compile-extra-less")         gulp, config
	require("#{config.req.tasks}/extra/compile-extra-sass")         gulp, config
	require("#{config.req.tasks}/extra/copy-extra-files")           gulp, config

	# format
	# ======
	require("#{config.req.tasks}/format/absolute-css-urls")         gulp, config

	# manage
	# ======
	require("#{config.req.tasks}/manage/bower")                     gulp, config

	# minify
	# ======
	require("#{config.req.tasks}/minify/cache-bust")                gulp, config
	require("#{config.req.tasks}/minify/concat-scripts-and-styles") gulp, config
	require("#{config.req.tasks}/minify/css-file-split")            gulp, config
	require("#{config.req.tasks}/minify/inline-css-imports")        gulp, config
	require("#{config.req.tasks}/minify/minify-client")             gulp, config
	require("#{config.req.tasks}/minify/minify-css")                gulp, config
	require("#{config.req.tasks}/minify/minify-html")               gulp, config
	require("#{config.req.tasks}/minify/minify-images")             gulp, config
	require("#{config.req.tasks}/minify/minify-js")                 gulp, config
	require("#{config.req.tasks}/minify/minify-server")             gulp, config
	require("#{config.req.tasks}/minify/minify-spa")                gulp, config
	require("#{config.req.tasks}/minify/template-cache")            gulp, config

	# server
	# ======
	require("#{config.req.tasks}/server/find-open-port")            gulp, config
	require("#{config.req.tasks}/server/start-server")              gulp, config
	require("#{config.req.tasks}/server/spawn-server")              gulp, config
	require("#{config.req.tasks}/server/nodemon")                   gulp, config, bs

	# client test
	# ===========
	require("#{config.req.tasks}/test/client/build-inject-angular-mocks") gulp, config
	require("#{config.req.tasks}/test/client/build-client-test-files")    gulp, config
	require("#{config.req.tasks}/test/client/clean-rb-client-test-src")   gulp, config
	require("#{config.req.tasks}/test/client/clean-client-test-dist")     gulp, config
	require("#{config.req.tasks}/test/client/copy-angular-mocks")         gulp, config
	require("#{config.req.tasks}/test/client/copy-client-tests")          gulp, config
	require("#{config.req.tasks}/test/client/run-client-tests")           gulp, config

	# server test
	# ===========
	require("#{config.req.tasks}/test/server/clean-server-test-dist")     gulp, config
	require("#{config.req.tasks}/test/server/copy-server-tests")          gulp, config
	require("#{config.req.tasks}/test/server/run-server-tests")           gulp, config

	# watch
	# =====
	require("#{config.req.tasks}/watch/watch")                      gulp, config, bs
	require("#{config.req.tasks}/watch/watch-build-spa")            gulp, config


