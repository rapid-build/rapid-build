angular.module('rapid-build').constant 'GETTING_STARTED', [
	label: 'Dependencies'
	icon:  'fa-check-circle'
	info:  'these must be installed first'
	html:
		class: items2: info: 'parens'
		headings: items2: false
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
, # =================================================================
	label: 'Installation'
	icon:  'fa-download'
	html:
		class: items2: info: 'parens'
		headings: items2: false
	items: [
		label: 'One time install.'
		info:  'the install is fairly big'
	,
		label: 'Use it for building multiple projects.'
	]
	example:
		lang: 'bash'
		code: """
			npm install rapid-build -g
		"""
, # =================================================================
	label: 'Directory Structure'
	icon: 'fa-folder-open'
	html:
		class: items2: info: 'parens'
		headings: items2: false
	items: [
		icon:  'fa-exclamation-circle'
		label: 'Must have package.json, everthing else is optional.'
	,
		label: 'Rapid build will be expecting this directory structure.'
	,
		label: 'If you like, you can change the directory names
				see build <a href="/build-options#src">option src</a>.'
	]
	example:
		lang: 'coffee'
		hideLang: true
		clipboard: false
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
			package.json # (required)
			rapid-build.json # (build options - can be cson, json or js file)
		"""
, # =================================================================
	label: 'Quick Start'
	icon:  'ion-ios-redo'
	iconSize: 'large'
	info:  'option'
	html:
		class: items2: info: 'parens'
		headings: items2: false
	items: [
		label: 'Want a quick application structure fast?'
	,
		label: 'Then run the following:'
		items: [
			label: 'It will create the above <a href="#directory-structure" rb-scroll>directory</a> structure'
		,
			label: 'with a couple simple files.'
			info:  'will not override your files or dirs'
		]
	]
	example:
		lang: 'bash'
		code: """
			rapid-build --quick-start
		"""
, # =================================================================
	label: 'rapid-build.json'
	icon: 'fa-cogs'
	info: 'example in cson'
	html:
		class: items2: info: 'parens'
		headings: items2: false
	items: [
		label: 'More than likely you will need to customize your builds.'
		info:  'No problem!'
	,
		label: 'There are many <a href="/build-options">build options</a> available for you.'
		info:  'options go in this file'
	,
		label: 'Copy rapid-build.cson and save it to the root of your project.'
	,
		label: 'Change it to json or js if you like.'
	,
		icon:  'fa-exclamation-circle'
		label: 'File name must be rapid-build and can be
				<a target="_blank" href="https://github.com/bevry/cson/blob/master/README.md">cson</a>,
				json or js file.'
	,
		label: '<a target="_blank" href="https://github.com/jyounce/rapid-build/blob/master/docs/rapid-build.cson">Example</a>
				build options used to create this site.'
	]
	example:
		lang: 'cson'
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
, # =================================================================
	label: 'Got it now what?'
	icon:  'fa-thumbs-o-up'
	html:
		class: items2: info: 'parens'
		headings: items2: false
	items: [
		label: 'Time to start developing, <a href="/build-types">see build types</a>.'
	]
]

