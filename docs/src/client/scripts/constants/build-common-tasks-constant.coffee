angular.module('rapid-build').constant 'BUILD_COMMON_TASKS',
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





