angular.module('rapid-build').constant 'BUILD_TYPES',
	'common tasks':
		info: 'all builds do the following tasks first'
		tasks: [
			label: 'Install bower components.'
			info: 'if they aren\'t installed'
		,
			label: 'Copy src files to the dist directory:'
			subtasks: [
				label: 'css'
				type: '@dir client'
			,
				label: 'images'
				type: '@dir client'
			,
				label: 'js'
				type: '@dir client and server'
			,
				label: 'html'
				type: '@dir client'
			,
				label: 'libs'
				type: '@dir client'
				info: 'everything in the libs directory'
			,
				label: 'bower components'
				type: '@dir client'
				info: 'files in bower.json\'s main prop'
			,
				label: 'html'
				type: '@dir client'
			]
		,
			label: 'Compile src files to the dist directory:'
			subtasks: [
				label: 'coffee &#8594; js'
				type: '@dir client and server'
			,
				label: 'es6 &#8594; js'
				type: '@dir client and server'
			,
				label: 'less &#8594; css'
				type: '@dir client'
			,
				label: 'sass &#8594; css'
				type: '@dir client'
			]
		]

	'default':
		tasks: [
			label: 'Run common tasks.'
			info: '<a href="#common-tasks" rb-scroll>see common tasks</a>'
		,
			label: 'Build spa.html then copy to dist/client/.'
		,
			label: 'Start the server.'
		,
			label: 'Open the browser.'
		]
		example:
			lang: 'bash'
			clipboard: 'true'
			code: """
				node build
			"""

	'dev':
		info: 'run when developing'
		tasks: [
			label: 'Run default build.'
			info: '<a href="#default-build" rb-scroll>see default build</a>'
		,
			label: 'Fireup the file watchers.'
			info: 'on saving a file, the browser will refresh'
		]
		example:
			lang: 'bash'
			clipboard: 'true'
			code: """
				node build dev
			"""

	'prod':
		info: 'creates your distributable production folder'
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
			label: 'Cache bust dist/client/ files.'
			info: 'css, js, gif, jpg, jpeg and png'
		,
			label: 'Minify dist/server/ js files.'
		]
		example:
			lang: 'bash'
			clipboard: 'true'
			code: """
				node build prod
			"""

	'prod:server':
		info: 'see your prod build in the browser'
		tasks: [
			label: 'Run prod build.'
			info: '<a href="#prod-build" rb-scroll>see prod build</a>'
		,
			label: 'Start the server.'
		,
			label: 'Open the browser.'
		]
		example:
			lang: 'bash'
			clipboard: 'true'
			code: """
				node build prod:server
			"""

	'test':
		info: 'run to execute your tests'
		tasks: [
			label: 'Run common tasks.'
			info: '<a href="#common-tasks" rb-scroll>see common tasks</a>'
		,
			label: 'Copy client test scripts to dist/client/.'
		,
			label: 'Run client tests in
					<a target="_blank" href="http://phantomjs.org/">phantomjs</a>.'
		,
			label: 'Copy server test scripts to dist/server/.'
		,
			label: 'Run client tests in
					<a target="_blank" href="http://jasmine.github.io/">jasmine</a>.'
		]
		example:
			lang: 'bash'
			clipboard: 'true'
			code: """
				node build test
			"""






