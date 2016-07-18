angular.module('rapid-build').constant 'ABOUT', [
	label: 'Technologies'
	icon:  'fa-laptop'
	iconSize: 'large'
	iconWeight: 'strong'
	info:  'supported'
	html:
		class:
			items2: info: 'sep parens'
			items3: info: 'sep parens'
	items: [
		label: 'Languages'
		info:  'your choice'
		items: [
			label: 'html'
			info:  'client'
		,
			label: 'css, less and sass'
			info:  'client'
		,
			label: 'js, <a target="_blank" href="http://babeljs.io/">es6</a>
					and coffeescript'
			info:  'client and server'
		]
	,
		label: 'Frameworks'
		info: 'included'
		items: [
			label: '<a target="_blank" href="https://angularjs.org/">angular 1.x</a>'
			info:  'client, angular 2 support is coming'
		,
			label: '<a target="_blank" href="http://karma-runner.github.io/">karma</a>'
			info:  'client testing'
		,
			label: '<a target="_blank" href="http://jasmine.github.io/2.4/introduction.html">jasmine</a>'
			info:  'client and server testing'
		,
			label: '<a target="_blank" href="http://expressjs.com/">express</a>'
			info:  'server'
		]
	,
		label: 'Package Managers'
		items: [
			label: '<a target="_blank" href="http://bower.io/">bower</a>'
			info:  'client'
		]
	]
, # =================================================================
	label: 'Key Concepts'
	icon:  'fa-lightbulb-o'
	iconSize: 'large'
	html:
		class:
			items2: info: 'sep parens'
			items3: info: 'sep parens'
	items: [
		label: 'Src'
		info:  'source'
		items: [
			label: 'This is where you develop, your working files go here.'
		]
	,
		label: 'Dist'
		info:  'distributable'
		items: [
			label: 'This is where your distributable package/folder will be built.'
		,
			label: 'After your package/folder is built, it\'s ready to be deployed.'
		]
	,
		label: 'Client'
		items: [
			label: 'Directory for all your client side code.'
		]
	,
		label: 'Server'
		items: [
			label: 'Directory for all your server side code.'
		]
	]
, # =================================================================
	label: 'Benefits'
	icon:  'fa-line-chart'
	html:
		class:
			items2: info: 'sep parens'
			items3: info: 'sep parens'
	items: [
		label: 'Decoupled Build System'
		items: [
			label: 'Your build system is no longer coupled with your source code.'
		,
			label: 'Development becomes easier because your project structure is clear and concise.'
		]
	,
		label: 'One Build for All Your Projects'
		items: [
			label: 'No more reinventing the wheel.'
		]
	]
, # =================================================================
	label: 'Features'
	icon:  'fa-star-o'
	iconSize: 'large'
	html:
		class:
			items2: info: 'sep parens'
			items3: info: 'sep parens'
	items: [
		label: '<a href="/build-types">See Build Types</a>'
	]
, # =================================================================
	label: 'How do I start?'
	html:
		class:
			items2: info: 'sep parens'
			items3: info: 'sep parens'
	items: [
		label: '<a href="/getting-started">See Getting Started</a>'
	]
]




