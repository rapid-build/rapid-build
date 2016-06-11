angular.module('rapid-build').constant 'BUILD_TYPES',
	# MAIN
	# ====
	main:
		'default':
			tasks: [
				label: 'Run common tasks.'
				info: '<a href="#common-tasks" rb-scroll>see common tasks</a>'
			,
				label: 'Build spa.html then copy to dist/client/.'
			,
				label: 'Start web server.'
			,
				label: 'Open the browser.'
			]
			example:
				code: """
					node build
				"""

		'dev':
			info: 'run when developing'
			tasks: [
				label: 'Run default build.'
				info: '<a href="#default" rb-scroll>see default build</a>'
			,
				label: 'Fireup the file watchers.'
				info: 'on saving a file, the browser will refresh'
			]
			example:
				code: """
					node build dev
				"""

		'prod':
			info: 'creates your distributable package/folder'
			tasks: [
				label: 'Run common tasks.'
				info: '<a href="#common-tasks" rb-scroll>see common tasks</a>'
			,
				label: 'Minify dist/client/ files:'
				info: 'css, html and js'
			,
				label: 'Concatenate dist/client/ files:'
				subtasks: [
					label: 'css'
					info: 'create styles.min.css'
				,
					label: 'js'
					info: 'create scripts.min.css'
				]
			,
				label: 'Build spa.html then copy to dist/client/.'
			,
				label: 'Minify spa.html.'
			,
				label: '<a target="_blank" href="https://css-tricks.com/strategies-for-cache-busting-css/#article-header-id-2">Cache bust</a>
						dist/client/ files.'
				info: 'css, js, gif, jpg, jpeg and png'
			,
				label: 'Minify dist/server/ js files.'
			]
			example:
				code: """
					node build prod
				"""

		'prod:server':
			info: 'see your prod build in the browser'
			tasks: [
				label: 'Run prod build.'
				info: '<a href="#prod" rb-scroll>see prod build</a>'
			,
				label: 'Start web server.'
			,
				label: 'Open the browser.'
			]
			example:
				code: """
					node build prod:server
				"""

		'test':
			info: 'run to execute your client and server tests'
			tasks: [
				label: 'Run common tasks.'
				info: '<a href="#common-tasks" rb-scroll>see common tasks</a>'
			,
				label: 'Build spa.html then copy to dist/client/.'
			,
				label: 'Copy and compile client test scripts to dist/client/.'
			,
				label: 'Start
						<a target="_blank" href="http://karma-runner.github.io/">karma</a>
						server.'
				info: 'for client tests'
			,
				label: 'Run client tests in
						<a target="_blank" href="http://phantomjs.org/">phantomjs</a>.'
				info: 'write
					   <a target="_blank" href="http://jasmine.github.io/2.4/introduction.html">jasmine</a>
					   tests'
			,
				label: 'Stop karma server.'
			,
				label: 'Copy and compile server test scripts to dist/server/.'
			,
				label: 'Start web server.'
				info: 'for server tests'
			,
				label: 'Run server tests.'
				info: 'write
					   <a target="_blank" href="http://jasmine.github.io/2.4/introduction.html">jasmine</a>
					   tests'
			,
				label: 'Stop web server.'
			]
			example:
				code: """
					node build test
				"""

	# VARIATIONS
	# ==========
	variations:
		'test:client':
			tasks: [
				label: 'Run test build\'s client tasks only.'
				info: '<a href="#test" rb-scroll>see test build</a>'
			]
			example:
				code: """
					node build test:client
				"""

		'test:server':
			tasks: [
				label: 'Run test build\'s server tasks only.'
				info: '<a href="#test" rb-scroll>see test build</a>'
			]
			example:
				code: """
					node build test:server
				"""

		'dev:test':
			info: 'run when developing tests'
			tasks: [
				label: 'Run combination of dev and test build.'
				info: '<a href="#dev" rb-scroll>see dev</a>
					   and
					   <a href="#test" rb-scroll>test builds</a>'
			,
				label: 'Fireup the test file watchers.'
				info: 'on saving a test file, the test will run'
			,
				label: 'Karma and web servers do not stop.'
			]
			example:
				code: """
					node build dev:test
				"""

		'dev:test:client':
			tasks: [
				label: 'Run dev:test build\'s client tasks only.'
				info: '<a href="#dev:test" rb-scroll>see dev:test build</a>'
			,
				label: 'This build does not start the web server.'
			]
			example:
				code: """
					node build dev:test:client
				"""

		'dev:test:server':
			tasks: [
				label: 'Run dev:test build\'s server tasks only.'
				info: '<a href="#dev:test" rb-scroll>see dev:test build</a>'
			]
			example:
				code: """
					node build dev:test:server
				"""

		'prod:test':
			tasks: [
				label: 'Run prod build\'s client tasks.'
				info: '<a href="#prod" rb-scroll>see prod</a>'
			,
				label: 'Run test build\'s client tasks.'
				info: '<a href="#test" rb-scroll>see test</a>'
				subtasks: [
					label: 'Excludes tasks that have already ran.'
				]
			,
				label: 'Run prod build\'s server tasks.'
				info: '<a href="#prod" rb-scroll>see prod</a>'
			,
				label: 'Run test build\'s server tasks.'
				info: '<a href="#test" rb-scroll>see test</a>'
				subtasks: [
					label: 'Excludes tasks that have already ran.'
				]
			,
				label: 'Delete client and server test files if no tests fail.'
			,
				label: 'If a test fails, the build will fail.'
				subtasks: [
					label: 'test-results.json will be created
							in dist client or server root.'
				]
			]
			example:
				code: """
					node build prod:test
				"""

		'prod:test:client':
			tasks: [
				label: 'Run prod:test build\'s client tasks only.'
				info: '<a href="#prod:test" rb-scroll>see prod:test build</a>'
			]
			example:
				code: """
					node build prod:test:client
				"""

		'prod:test:server':
			tasks: [
				label: 'Run prod:test build\'s server tasks only.'
				info: '<a href="#prod:test" rb-scroll>see prod:test build</a>'
			]
			example:
				code: """
					node build prod:test:server
				"""






