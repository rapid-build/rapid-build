angular.module('rapid-build').constant 'BUILD_TYPES',
	'common tasks':
		info: '(all 4 builds do the following tasks first)'
		tasks: [
			label: 'Install bower components.'
			info: '(if they aren\'t installed)'
		,
			label: 'Copy files to the dist directory:'
			subtasks: [
				label: 'css'
				info: '@dir client'
			,
				label: 'images'
				info: '@dir client'
			,
				label: 'js'
				info: '@dir client and server'
			,
				label: 'html'
				info: '@dir client'
			,
				label: 'libs'
				info: '@dir client (everything in the libs directory)'
			,
				label: 'bower components'
				info: '@dir client (files in bower.json\'s main prop)'
			,
				label: 'html'
				info: '@dir client'
			]
		,
			label: 'Compile files to the dist directory:'
			subtasks: [
				label: 'coffee &#8594; js'
				info: '@dir client and server'
			,
				label: 'es6 &#8594; js'
				info: '@dir client and server'
			,
				label: 'less &#8594; css'
				info: '@dir client'
			,
				label: 'sass &#8594; css'
				info: '@dir client'
			]
		]

	'default build':
		tasks: [
			label: 'Run common tasks.'
			info: '(<a href="#common-tasks" rb-scroll>see common tasks</a>)'
		,
			label: 'Build spa.html then copy to dist/client/.'
		,
			label: 'Start the server.'
		,
			label: 'Open the browser.'
		]

	'dev build':
		tasks: [
			label: 'Run default build.'
			info: '(<a href="#default-build" rb-scroll>see default build</a>)'
		,
			label: 'Fireup the file watchers.'
			info: '(on saving a file, the browser will refresh)'
		]

	'prod build':
		tasks: [
			label: 'Run common tasks.'
			info: '(<a href="#common-tasks" rb-scroll>see common tasks</a>)'
		,
			label: 'Minify dist/client/ files:'
			info: '(css, html and js)'
		,
			label: 'Concatenate dist/client/ files:'
			subtasks: [
				label: 'css'
				info: '(create styles.min.css)'
			,
				label: 'js'
				info: '(create scripts.min.css)'
			]
		,
			label: 'Build spa.html then copy to dist/client/.'
		,
			label: 'Minify spa.html.'
		,
			label: 'Cache bust dist/client/ files.'
			info: '(css, js, gif, jpg, jpeg and png)'
		,
			label: 'Minify dist/server/ js files.'
		]

	'test build':
		tasks: [
			label: 'Run common tasks.'
			info: '(<a href="#common-tasks" rb-scroll>see common tasks</a>)'
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






