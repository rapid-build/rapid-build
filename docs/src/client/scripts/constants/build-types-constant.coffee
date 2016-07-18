angular.module('rapid-build').constant 'BUILD_TYPES',
	# MAIN
	# ====
	main: [
		label: 'default'
		icon:  'fa-wrench'
		html:
			class: items2: info: 'parens', list: 'ordered'
			headings: items2: false
		items: [
			label: 'Run common tasks.'
			info:  '<a href="#common-tasks" rb-scroll>see common tasks</a>'
		,
			label: 'Build spa.html then copy to dist/client/.'
		,
			label: 'Start web server.'
		,
			label: 'Open browser.'
		]
		example:
			lang:    'bash'
			size:    'small'
			spacing: 'large'
			code: """
				rapid-build
			"""
	, # =================================================================
		label: 'dev'
		icon:  'fa-wrench'
		info:  'run when developing'
		html:
			class: items2: info: 'parens', list: 'ordered'
			headings: items2: false
		items: [
			label: 'Run default build.'
			info:  '<a href="#default" rb-scroll>see default build</a>'
		,
			label: 'Fireup the file watchers.'
			info:  'on saving a file, the browser will refresh'
		]
		example:
			lang:    'bash'
			size:    'small'
			spacing: 'large'
			code: """
				rapid-build dev
			"""
	, # =================================================================
		label: 'prod'
		icon:  'fa-wrench'
		info: 'creates your distributable package/folder'
		html:
			class: items2: info: 'parens', list: 'ordered'
			headings: items2: false
		items: [
			label: 'Run common tasks.'
			info:  '<a href="#common-tasks" rb-scroll>see common tasks</a>'
		,
			label: 'Minify dist/client/ files:'
			info:  'css, html and js'
		,
			label: 'Concatenate dist/client/ files:'
			items: [
				label: 'css'
				info:  'create styles.min.css'
			,
				label: 'js'
				info:  'create scripts.min.css'
			]
		,
			label: 'Build spa.html then copy to dist/client/.'
		,
			label: 'Minify spa.html.'
		,
			label: '<a target="_blank" href="https://css-tricks.com/strategies-for-cache-busting-css/#article-header-id-2">Cache bust</a>
					dist/client/ files.'
			info:  'css, js, gif, jpg, jpeg and png'
		,
			label: 'Minify dist/server/ js files.'
		]
		example:
			lang:    'bash'
			size:    'small'
			spacing: 'large'
			code: """
				rapid-build prod
			"""
	, # =================================================================
		label: 'prod:server'
		icon:  'fa-wrench'
		info: 'see your prod build in the browser'
		html:
			class: items2: info: 'parens', list: 'ordered'
			headings: items2: false
		items: [
			label: 'Run prod build.'
			info:  '<a href="#prod" rb-scroll>see prod build</a>'
		,
			label: 'Start web server.'
		,
			label: 'Open browser.'
		]
		example:
			lang:    'bash'
			size:    'small'
			spacing: 'large'
			code: """
				rapid-build prod:server
			"""
	, # =================================================================
		label: 'test'
		icon:  'fa-wrench'
		info: 'run to execute your client and server tests'
		html:
			class: items2: info: 'parens', list: 'ordered'
			headings: items2: false
		items: [
			label: 'Run common tasks.'
			info:  '<a href="#common-tasks" rb-scroll>see common tasks</a>'
		,
			label: 'Build spa.html then copy to dist/client/.'
		,
			label: 'Copy and compile client test scripts to dist/client/.'
		,
			label: 'Start
					<a target="_blank" href="http://karma-runner.github.io/">karma</a>
					server.'
			info:  'for client tests'
		,
			label: 'Run client tests in
					<a target="_blank" href="http://phantomjs.org/">phantomjs</a>.'
			info:  'write
					<a target="_blank" href="http://jasmine.github.io/2.4/introduction.html">jasmine</a>
					tests'
		,
			label: 'Stop karma server.'
		,
			label: 'Copy and compile server test scripts to dist/server/.'
		,
			label: 'Start web server.'
			info:  'for server tests'
		,
			label: 'Run server tests.'
			info:  'write
					<a target="_blank" href="http://jasmine.github.io/2.4/introduction.html">jasmine</a>
					tests'
		,
			label: 'Stop web server.'
		]
		example:
			lang:    'bash'
			size:    'small'
			spacing: 'large'
			code: """
				rapid-build test
			"""
	]

	# VARIATIONS
	# ==========
	variations: [
		label: 'test:client'
		icon:  'fa-wrench'
		html:
			class: items2: info: 'parens', list: 'ordered'
			headings: items2: false
		items: [
			label: 'Run test build\'s client tasks only.'
			info:  '<a href="#test" rb-scroll>see test build</a>'
		]
		example:
			lang:    'bash'
			size:    'small'
			spacing: 'large'
			code: """
				rapid-build test:client
			"""
	, # =================================================================
		label: 'test:server'
		icon:  'fa-wrench'
		html:
			class: items2: info: 'parens', list: 'ordered'
			headings: items2: false
		items: [
			label: 'Run test build\'s server tasks only.'
			info:  '<a href="#test" rb-scroll>see test build</a>'
		]
		example:
			lang:    'bash'
			size:    'small'
			spacing: 'large'
			code: """
				rapid-build test:server
			"""
	, # =================================================================
		label: 'dev:test'
		icon:  'fa-wrench'
		info: 'run when developing tests'
		html:
			class: items2: info: 'parens', list: 'ordered'
			headings: items2: false
		items: [
			label: 'Run combination of dev and test build.'
			info:  '<a href="#dev" rb-scroll>see dev</a>
					and
					<a href="#test" rb-scroll>test builds</a>'
		,
			label: 'Fireup the test file watchers.'
			info:  'on saving a test file, the test will run'
		,
			label: 'Karma and web servers do not stop.'
		]
		example:
			lang:    'bash'
			size:    'small'
			spacing: 'large'
			code: """
				rapid-build dev:test
			"""
	, # =================================================================
		label: 'dev:test:client'
		icon:  'fa-wrench'
		html:
			class: items2: info: 'parens', list: 'ordered'
			headings: items2: false
		items: [
			label: 'Run dev:test build\'s client tasks only.'
			info:  '<a href="#dev:test" rb-scroll>see dev:test build</a>'
		,
			label: 'This build does not start the web server.'
		]
		example:
			lang:    'bash'
			size:    'small'
			spacing: 'large'
			code: """
				rapid-build dev:test:client
			"""
	, # =================================================================
		label: 'dev:test:server'
		icon:  'fa-wrench'
		html:
			class: items2: info: 'parens', list: 'ordered'
			headings: items2: false
		items: [
			label: 'Run dev:test build\'s server tasks only.'
			info:  '<a href="#dev:test" rb-scroll>see dev:test build</a>'
		]
		example:
			lang:    'bash'
			size:    'small'
			spacing: 'large'
			code: """
				rapid-build dev:test:server
			"""
	, # =================================================================
		label: 'prod:test'
		icon:  'fa-wrench'
		html:
			class: items2: info: 'parens', list: 'ordered'
			headings: items2: false
		items: [
			label: 'Run prod build\'s client tasks.'
			info:  '<a href="#prod" rb-scroll>see prod</a>'
		,
			label: 'Run test build\'s client tasks.'
			info: '<a href="#test" rb-scroll>see test</a>'
			items: [
				label: 'Excludes tasks that have already ran.'
			]
		,
			label: 'Run prod build\'s server tasks.'
			info:  '<a href="#prod" rb-scroll>see prod</a>'
		,
			label: 'Run test build\'s server tasks.'
			info:  '<a href="#test" rb-scroll>see test</a>'
			items: [
				label: 'Excludes tasks that have already ran.'
			]
		,
			label: 'Delete client and server test files if no tests fail.'
		,
			label: 'If a test fails, the build will fail.'
			items: [
				label: 'test-results.json will be created
						in dist client or server root.'
			]
		]
		example:
			lang:    'bash'
			size:    'small'
			spacing: 'large'
			code: """
				rapid-build prod:test
			"""
	, # =================================================================
		label: 'prod:test:client'
		icon:  'fa-wrench'
		html:
			class: items2: info: 'parens', list: 'ordered'
			headings: items2: false
		items: [
			label: 'Run prod:test build\'s client tasks only.'
			info:  '<a href="#prod:test" rb-scroll>see prod:test build</a>'
		]
		example:
			lang:    'bash'
			size:    'small'
			spacing: 'large'
			code: """
				rapid-build prod:test:client
			"""
	, # =================================================================
		label: 'prod:test:server'
		icon:  'fa-wrench'
		html:
			class: items2: info: 'parens', list: 'ordered'
			headings: items2: false
		items: [
			label: 'Run prod:test build\'s server tasks only.'
			info:  '<a href="#prod:test" rb-scroll>see prod:test build</a>'
		]
		example:
			lang:    'bash'
			size:    'small'
			spacing: 'large'
			code: """
				rapid-build prod:test:server
			"""
	]






