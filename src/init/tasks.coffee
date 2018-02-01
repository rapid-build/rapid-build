# Available tasks prefixed with config.rb.prefix.task.
# ====================================================
module.exports = (gulp, config) ->
	taskManager = require("#{config.req.manage}/task-manager") config, gulp

	# MUST RUN FIRST (as of gulp >= v4, order doesn't matter for the rest)
	# ==============
	taskManager.addTask 'clean-files', '/clean/clean-files'

	# browser
	# =======
	taskManager.addTask 'browser-sync', '/browser/browser-sync', run: 'init'
	taskManager.addTask 'open-browser', '/browser/open-browser'

	# build
	# =====
	taskManager.addTask 'build-angular-bootstrap',    '/build/build-angular-bootstrap'
	taskManager.addTask 'build-angular-modules',      '/build/build-angular-modules'
	taskManager.addTask 'build-bower-json',           '/build/build-bower-json'
	taskManager.addTask 'build-config',               '/build/build-config'
	taskManager.addTask 'build-files',                '/build/build-files', deps: ['clean-files']
	taskManager.addTask 'build-prod-files',           '/build/build-prod-files'
	taskManager.addTask 'build-prod-files-blueprint', '/build/build-prod-files-blueprint'
	taskManager.addTask 'build-spa:dev',              '/build/build-spa',      env: 'dev'
	taskManager.addTask 'build-spa:prod',             '/build/build-spa',      env: 'prod'
	taskManager.addTask 'build-spa-file:dev',         '/build/build-spa-file', env: 'dev'
	taskManager.addTask 'build-spa-file:prod',        '/build/build-spa-file', env: 'prod'
	taskManager.addTask 'build-spa-placeholders',     '/build/build-spa-placeholders'

	# clean
	# =====
	taskManager.addTask 'clean-dist',           '/clean/clean-dist'
	taskManager.addTask 'clean-rb-client',      '/clean/clean-rb-client'
	taskManager.addTask 'clean-rb-client:test', '/clean/clean-rb-client', env: 'test'
	taskManager.addTask 'cleanup-client',       '/clean/cleanup-client'

	# common
	# ======
	taskManager.addTask 'common',             '/common/common'
	taskManager.addTask 'common-client',      '/common/common-client'
	taskManager.addTask 'common-server',      '/common/common-server'
	taskManager.addTask 'common-test-client', '/common/common-test-client'
	taskManager.addTask 'common-test-server', '/common/common-test-server'

	# compile
	# =======
	taskManager.addTask 'coffee:client',     '/compile/coffee', loc: 'client'
	taskManager.addTask 'coffee:server',     '/compile/coffee', loc: 'server'
	taskManager.addTask 'es6:client',        '/compile/es6',    loc: 'client'
	taskManager.addTask 'es6:server',        '/compile/es6',    loc: 'server'
	taskManager.addTask 'typescript:client', '/compile/typescript-client'
	taskManager.addTask 'typescript:server', '/compile/typescript-server'
	taskManager.addTask 'less',              '/compile/less'
	taskManager.addTask 'sass',              '/compile/sass'

	# config
	# ======
	taskManager.addTask 'set-env-config',              '/config/set-env-config'
	taskManager.addTask 'update-angular-mocks-config', '/config/update-angular-mocks-config'

	# copy
	# ====
	taskManager.addTask 'copy-bower_components',    '/copy/copy-bower_components'
	taskManager.addTask 'copy-css',                 '/copy/copy-css'
	taskManager.addTask 'copy-html',                '/copy/copy-html'
	taskManager.addTask 'copy-images',              '/copy/copy-images'
	taskManager.addTask 'copy-js:client',           '/copy/copy-js', loc: 'client'
	taskManager.addTask 'copy-js:server',           '/copy/copy-js', loc: 'server'
	taskManager.addTask 'copy-libs',                '/copy/copy-libs'
	taskManager.addTask 'copy-server-config',       '/copy/copy-server-config'
	taskManager.addTask 'copy-server-info',         '/copy/copy-server-info'
	taskManager.addTask 'copy-server-node_modules', '/copy/copy-server-node_modules'
	taskManager.addTask 'copy-server-pkgs',         '/copy/copy-server-pkgs'
	taskManager.addTask 'copy-spa',                 '/copy/copy-spa'
	taskManager.addTask 'copy-views',               '/copy/copy-views'

	# extra
	# =====
	taskManager.addTask 'compile-extra-coffee:client',       '/extra/compile-extra-coffee',       loc: 'client'
	taskManager.addTask 'compile-extra-es6:client',          '/extra/compile-extra-es6',          loc: 'client'
	taskManager.addTask 'compile-extra-html-scripts:client', '/extra/compile-extra-html-scripts', loc: 'client'
	taskManager.addTask 'compile-extra-less:client',         '/extra/compile-extra-less',         loc: 'client'
	taskManager.addTask 'compile-extra-less:server',         '/extra/compile-extra-less',         loc: 'server'
	taskManager.addTask 'compile-extra-sass:client',         '/extra/compile-extra-sass',         loc: 'client'
	taskManager.addTask 'compile-extra-sass:server',         '/extra/compile-extra-sass',         loc: 'server'
	taskManager.addTask 'copy-extra-files:client',           '/extra/copy-extra-files',           loc: 'client'
	taskManager.addTask 'copy-extra-files:server',           '/extra/copy-extra-files',           loc: 'server'

	# format
	# ======
	taskManager.addTask 'absolute-css-urls',    '/format/absolute-css-urls'
	taskManager.addTask 'relative-css-urls',    '/format/relative-css-urls'
	taskManager.addTask 'update-css-urls:dev',  '/format/update-css-urls', env: 'dev'
	taskManager.addTask 'update-css-urls:prod', '/format/update-css-urls', env: 'prod'

	# generate
	# ========
	taskManager.addTask 'generate-pkg', '/generate/generate-pkg'

	# inline
	# ======
	taskManager.addTask 'inline-js-html-imports:dev',  '/inline/js-html-imports', env: 'dev'
	taskManager.addTask 'inline-js-html-imports:prod', '/inline/js-html-imports', env: 'prod'
	taskManager.addTask 'inline-html-assets:dev',      '/inline/html-assets',     env: 'dev'
	taskManager.addTask 'inline-html-assets:prod',     '/inline/html-assets',     env: 'prod'

	# manage
	# ======
	taskManager.addTask 'bower', '/manage/bower'

	# minify
	# ======
	taskManager.addTask 'cache-bust',                '/minify/cache-bust'
	taskManager.addTask 'concat-scripts-and-styles', '/minify/concat-scripts-and-styles'
	taskManager.addTask 'css-file-split',            '/minify/css-file-split'
	taskManager.addTask 'inline-css-imports',        '/minify/inline-css-imports'
	taskManager.addTask 'minify-client',             '/minify/minify-client'
	taskManager.addTask 'minify-css',                '/minify/minify-css'
	taskManager.addTask 'minify-html',               '/minify/minify-html'
	taskManager.addTask 'minify-images',             '/minify/minify-images'
	taskManager.addTask 'minify-js',                 '/minify/minify-js'
	taskManager.addTask 'minify-js-html-imports',    '/minify/minify-js-html-imports'
	taskManager.addTask 'minify-server',             '/minify/minify-server'
	taskManager.addTask 'minify-spa',                '/minify/minify-spa'
	taskManager.addTask 'template-cache',            '/minify/template-cache'

	# pack
	# ====
	taskManager.addTask 'pack-dist', '/pack/pack-dist'

	# server
	# ======
	taskManager.addTask 'find-open-port',             '/server/find-open-port'
	taskManager.addTask 'find-open-port:test:client', '/server/find-open-port', loc: 'test:client'
	taskManager.addTask 'nodemon',                    '/server/nodemon'
	taskManager.addTask 'spawn-server',               '/server/spawn-server'
	taskManager.addTask 'start-server',               '/server/start-server'
	taskManager.addTask 'start-server:dev',           '/server/start-server', env: 'dev'
	taskManager.addTask 'stop-server',                '/server/stop-server'

	# client test
	# ===========
	taskManager.addTask 'build-inject-angular-mocks', '/test/client/build-inject-angular-mocks'
	taskManager.addTask 'build-client-test-files',    '/test/client/build-client-test-files'
	taskManager.addTask 'clean-rb-client-test-src',   '/test/client/clean-rb-client-test-src'
	taskManager.addTask 'clean-client-test-dist',     '/test/client/clean-client-test-dist'
	taskManager.addTask 'copy-angular-mocks',         '/test/client/copy-angular-mocks'
	taskManager.addTask 'copy-client-tests',          '/test/client/copy-client-tests'
	taskManager.addTask 'run-client-tests',           '/test/client/run-client-tests'
	taskManager.addTask 'run-client-tests:dev',       '/test/client/run-client-tests', env: 'dev'

	# server test
	# ===========
	taskManager.addTask 'clean-server-test-dist', '/test/server/clean-server-test-dist'
	taskManager.addTask 'copy-server-tests',      '/test/server/copy-server-tests'
	taskManager.addTask 'run-server-tests',       '/test/server/run-server-tests'
	taskManager.addTask 'run-server-tests:dev',   '/test/server/run-server-tests', env: 'dev'

	# watch
	# =====
	taskManager.addTask 'watch',           '/watch/watch'
	taskManager.addTask 'watch-build-spa', '/watch/watch-build-spa'


