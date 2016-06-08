# Order doesn't matter.
# Available tasks prefixed with config.rb.prefix.task.
# ====================================================
module.exports = (gulp, config) ->
	taskHelp = require("#{config.req.helpers}/tasks") config, gulp

	# browser
	# =======
	taskHelp.addTask 'browser-sync', '/browser/browser-sync', run: 'init'
	taskHelp.addTask 'open-browser', '/browser/open-browser'

	# build
	# =====
	taskHelp.addTask 'build-angular-bootstrap',    '/build/build-angular-bootstrap'
	taskHelp.addTask 'build-angular-modules',      '/build/build-angular-modules'
	taskHelp.addTask 'build-bower-json',           '/build/build-bower-json'
	taskHelp.addTask 'build-config',               '/build/build-config'
	taskHelp.addTask 'build-files',                '/build/build-files',  deps: ['clean-files']
	taskHelp.addTask 'build-prod-files',           '/build/build-prod-files'
	taskHelp.addTask 'build-prod-files-blueprint', '/build/build-prod-files-blueprint'
	taskHelp.addTask 'build-spa',                  '/build/build-spa', taskCB: true
	taskHelp.addTask 'build-spa:prod',             '/build/build-spa', taskCB: true, env: 'prod'
	taskHelp.addTask 'build-spa-file',             '/build/build-spa-file'
	taskHelp.addTask 'build-spa-file:prod',        '/build/build-spa-file', env: 'prod'
	taskHelp.addTask 'build-spa-placeholders',     '/build/build-spa-placeholders'

	# clean
	# =====
	taskHelp.addTask 'clean-dist',           '/clean/clean-dist'
	taskHelp.addTask 'clean-files',          '/clean/clean-files'
	taskHelp.addTask 'clean-rb-client',      '/clean/clean-rb-client'
	taskHelp.addTask 'clean-rb-client:test', '/clean/clean-rb-client', env: 'test'
	taskHelp.addTask 'cleanup-client',       '/clean/cleanup-client'

	# common
	# ======
	taskHelp.addTask 'common',             '/common/common',             taskCB: true
	taskHelp.addTask 'common-client',      '/common/common-client',      taskCB: true
	taskHelp.addTask 'common-server',      '/common/common-server',      taskCB: true
	taskHelp.addTask 'common-test-client', '/common/common-test-client', taskCB: true
	taskHelp.addTask 'common-test-server', '/common/common-test-server', taskCB: true

	# compile
	# =======
	taskHelp.addTask 'coffee:client', '/compile/coffee', loc: 'client'
	taskHelp.addTask 'coffee:server', '/compile/coffee', loc: 'server'
	taskHelp.addTask 'es6:client',    '/compile/es6',    loc: 'client'
	taskHelp.addTask 'es6:server',    '/compile/es6',    loc: 'server'
	taskHelp.addTask 'less',          '/compile/less'
	taskHelp.addTask 'sass',          '/compile/sass'

	# config
	# ======
	taskHelp.addTask 'set-env-config',              '/config/set-env-config'
	taskHelp.addTask 'update-angular-mocks-config', '/config/update-angular-mocks-config'

	# copy
	# ====
	taskHelp.addTask 'copy-bower_components',    '/copy/copy-bower_components'
	taskHelp.addTask 'copy-css',                 '/copy/copy-css'
	taskHelp.addTask 'copy-html',                '/copy/copy-html'
	taskHelp.addTask 'copy-images',              '/copy/copy-images'
	taskHelp.addTask 'copy-js:client',           '/copy/copy-js', loc: 'client'
	taskHelp.addTask 'copy-js:server',           '/copy/copy-js', loc: 'server'
	taskHelp.addTask 'copy-libs',                '/copy/copy-libs'
	taskHelp.addTask 'copy-server-config',       '/copy/copy-server-config'
	taskHelp.addTask 'copy-server-info',         '/copy/copy-server-info'
	taskHelp.addTask 'copy-server-node_modules', '/copy/copy-server-node_modules'
	taskHelp.addTask 'copy-spa',                 '/copy/copy-spa'
	taskHelp.addTask 'copy-views',               '/copy/copy-views', taskCB: true

	# extra
	# =====
	taskHelp.addTask 'compile-extra-coffee:client', '/extra/compile-extra-coffee', loc: 'client'
	taskHelp.addTask 'compile-extra-es6:client',    '/extra/compile-extra-es6',    loc: 'client'
	taskHelp.addTask 'compile-extra-less:client',   '/extra/compile-extra-less',   loc: 'client'
	taskHelp.addTask 'compile-extra-less:server',   '/extra/compile-extra-less',   loc: 'server'
	taskHelp.addTask 'compile-extra-sass:client',   '/extra/compile-extra-sass',   loc: 'client'
	taskHelp.addTask 'compile-extra-sass:server',   '/extra/compile-extra-sass',   loc: 'server'
	taskHelp.addTask 'copy-extra-files:client',     '/extra/copy-extra-files',     loc: 'client'
	taskHelp.addTask 'copy-extra-files:server',     '/extra/copy-extra-files',     loc: 'server'

	# format
	# ======
	taskHelp.addTask 'absolute-css-urls', '/format/absolute-css-urls'

	# generate
	# ========
	taskHelp.addTask 'generate-pkg', '/generate/generate-pkg'

	# manage
	# ======
	taskHelp.addTask 'bower', '/manage/bower'

	# minify
	# ======
	taskHelp.addTask 'cache-bust',                '/minify/cache-bust'
	taskHelp.addTask 'concat-scripts-and-styles', '/minify/concat-scripts-and-styles'
	taskHelp.addTask 'css-file-split',            '/minify/css-file-split'
	taskHelp.addTask 'inline-css-imports',        '/minify/inline-css-imports'
	taskHelp.addTask 'minify-client',             '/minify/minify-client', taskCB: true
	taskHelp.addTask 'minify-css',                '/minify/minify-css'
	taskHelp.addTask 'minify-html',               '/minify/minify-html'
	taskHelp.addTask 'minify-images',             '/minify/minify-images'
	taskHelp.addTask 'minify-js',                 '/minify/minify-js'
	taskHelp.addTask 'minify-server',             '/minify/minify-server'
	taskHelp.addTask 'minify-spa',                '/minify/minify-spa'
	taskHelp.addTask 'template-cache',            '/minify/template-cache'

	# server
	# ======
	taskHelp.addTask 'find-open-port',             '/server/find-open-port'
	taskHelp.addTask 'find-open-port:test:client', '/server/find-open-port', loc: 'test:client'
	taskHelp.addTask 'nodemon',                    '/server/nodemon'
	taskHelp.addTask 'spawn-server',               '/server/spawn-server'
	taskHelp.addTask 'start-server',               '/server/start-server', taskCB: true
	taskHelp.addTask 'start-server:dev',           '/server/start-server', taskCB: true, env: 'dev'
	taskHelp.addTask 'stop-server',                '/server/stop-server'

	# client test
	# ===========
	taskHelp.addTask 'build-inject-angular-mocks', '/test/client/build-inject-angular-mocks'
	taskHelp.addTask 'build-client-test-files',    '/test/client/build-client-test-files'
	taskHelp.addTask 'clean-rb-client-test-src',   '/test/client/clean-rb-client-test-src'
	taskHelp.addTask 'clean-client-test-dist',     '/test/client/clean-client-test-dist'
	taskHelp.addTask 'copy-angular-mocks',         '/test/client/copy-angular-mocks'
	taskHelp.addTask 'copy-client-tests',          '/test/client/copy-client-tests'
	taskHelp.addTask 'run-client-tests',           '/test/client/run-client-tests'
	taskHelp.addTask 'run-client-tests:dev',       '/test/client/run-client-tests', env: 'dev'

	# server test
	# ===========
	taskHelp.addTask 'clean-server-test-dist', '/test/server/clean-server-test-dist'
	taskHelp.addTask 'copy-server-tests',      '/test/server/copy-server-tests'
	taskHelp.addTask 'run-server-tests',       '/test/server/run-server-tests'
	taskHelp.addTask 'run-server-tests:dev',   '/test/server/run-server-tests', env: 'dev'

	# watch
	# =====
	taskHelp.addTask 'watch',           '/watch/watch'
	taskHelp.addTask 'watch-build-spa', '/watch/watch-build-spa', taskCB: true


