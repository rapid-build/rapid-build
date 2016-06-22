angular.module('rapid-build').constant 'GETTING_STARTED',
	'Dependencies':
		icon: 'fa-check-circle'
		info: 'these must be installed first'
		items: [
			label: '<a target="_blank" href="https://git-scm.com/downloads">
						<rb:icon kind="fa-code-fork"></rb:icon> Git
					</a>'
		,
			label: '<a target="_blank" href="https://nodejs.org/">
						<rb:icon kind="ion-social-nodejs"></rb:icon> Node.js
					</a>'
			info: 'version >= 4.0.0'
		]

	'Installation':
		icon: 'fa-download'
		items: [
			label: 'One time install.'
			info: 'the install is fairly big'
		,
			label: 'Use it for building multiple projects.'
		]
		example:
			lang: 'bash'
			clipboard: 'true'
			code: """
				npm install rapid-build -g
			"""

	'Directory Structure':
		icon: 'fa-folder-open'
		items: [
			label: '<rb:icon kind="fa-exclamation-circle"></rb:icon>
					Everthing is optional.'
		,
			label: 'Rapid build will be expecting this directory structure.'
		,
			label: 'If you like, you can change the directory names
					see build <a href="/build-options#src">option src</a>.'
		]
		example:
			hideLang: 'true'
			lang: 'coffee'
			code: """
				dist/ # (generated distributable folder created by rapid-build)
				src/
				├── client/
				│   ├── bower_components/ # (generated folder via bower.json)
				│   ├── images/
				│   │   └── gif, jpg, jpeg, png, etc..
				│   ├── libs/
				│   │   └── # (3rd party libraries that aren't bower components)
				│   ├── scripts/
				│   │   └── coffee, es6 or js
				│   ├── styles/
				│   │   └── css, less, sass or scss
				│   ├── test/
				│   │   └── coffee, es6 or js
				│   ├── views/
				│   │   └── html
				│   └── spa.html # (optional, see build options spa.src.filePath)
				└── server/
				    ├── test/
				    │   └── coffee, es6 or js
				    └── routes.{coffee,es6,js} # (optional, see build options dist.server.fileName)
				nodes_modules/ # (generated folder via package.json)
				bower.json
				package.json
				rapid-build.json # (build options - can be cson, json or js file)
			"""

	'rapid-build.json':
		icon: 'fa-cogs'
		info: 'example in cson'
		items: [
			label: 'More than likely you will need to customize your builds.'
			info: 'No problem!'
		,
			label: 'There are many <a href="/build-options">build options</a> available for you.'
			info: 'options go in this file'
		,
			label: 'Copy rapid-build.cson and save it to the root of your project.'
		,
			label: 'Change it to json or js if you like.'
		,
			label: '<rb:icon kind="fa-exclamation-circle"></rb:icon>
					File name must be rapid-build and can be
					<a target="_blank" href="https://github.com/bevry/cson/blob/master/README.md">cson</a>,
					json or js file.'
		,
			label: '<a target="_blank" href="https://github.com/jyounce/rapid-build/blob/master/docs/rapid-build.cson">Example</a>
					build options used to create this site.'
		]
		example:
			lang: 'cson'
			clipboard: 'true'
			code: """
				# rapid-build.cson
				# ================
				# common options for all build types
				common: {}

				# options for default, dev and test builds
				dev: {}

				# options for prod build
				prod: {}
			"""

	'Got it now what?':
		icon: 'fa-thumbs-o-up'
		items: [
			label: 'Time to start developing, <a href="/build-types">see build types</a>.'
		]


