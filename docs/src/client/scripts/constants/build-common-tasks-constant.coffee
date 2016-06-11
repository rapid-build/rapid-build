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
				info: 'everything in the
					   <a href="/getting-started#directory-structure">libs</a>
					   directory'
			,
				label: 'bower components'
				type: '@dir client'
				info: 'files listed in
					   <a target="_blank" href="https://github.com/bower/spec/blob/master/json.md">bower.json</a>
					   main property'
			]
		,
			label: 'Compile src files to the dist directory:'
			subtasks: [
				label: 'coffee &#8594; js'
				type: '@dir client and server'
			,
				label: '<a target="_blank" href="http://babeljs.io/">es6</a> &#8594; js'
				type: '@dir client and server'
			,
				label: 'less &#8594; css'
				type: '@dir client'
			,
				label: 'sass &#8594; css'
				type: '@dir client'
			]
		]





