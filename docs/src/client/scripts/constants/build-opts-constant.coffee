angular.module('rapid-build').constant 'BUILD_OPTS', [
	label: 'angular'
	icon:  'fa-cog'
	info:  'for angular 1.x'
	html:
		class: items2: list: 'small'
	items: [
		label: 'version'
		info:  '@type string, @default \'1.x\''
		items: [
			label: 'The version of angular to load.'
		,
			icon:  'fa-exclamation-circle'
			label: 'Currently the build does not support angular 2
					out of the box.'
		]
	,
		label: 'moduleName'
		info:  '@type string, @default \'app\''
		items: [
			label: 'Application module name.'
		,
			label: 'Value for ng-app in
					<a href="#spa" rb-scroll>spa.html</a> or angular\'s
					<a href="#angular.bootstrap" rb-scroll> bootstrap</a>.'
		]
	,
		label: 'modules'
		info:  '@type array of strings'
		items: [
			label: 'Additional angular modules to load.'
		,
			label: 'By default the build loads
					[\'ngResource\', \'ngRoute\', \'ngSanitize\'].'
		,
			label: 'And \'ngMockE2E\' based on
					angular.<a href="#angular.httpBackend[dev|prod]" rb-scroll>httpBackend</a>
					options.'
		]
	,
		label: 'bootstrap'
		info:  '@type boolean or string, @default false'
		items: [
			label: 'By default the build initializes angular via
					<a target="_blank" href="https://docs.angularjs.org/guide/bootstrap">ng-app</a>
					in <a href="#spa" rb-scroll>spa.html</a>.'
		,
			label: 'Provide true to use angular\'s
					<a target="_blank" href="https://docs.angularjs.org/guide/bootstrap#manual-initialization">bootstrap</a>
					method instead.'
			items: [
				label: 'The build will bootstrap on the document.'
			]
		,
			label: 'Or provide a
					<a target="_blank" href="https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector">css selector</a>
					<em class="sub parens">string</em> to the dom element to bootstrap.'
		,
			label: 'The bootstrap script will load last.'
		]
	,
		label: 'ngFormify'
		info:  '@type boolean, @default false'
		items: [
			label: 'Set to true to replace all html form tags with
					<a target="_blank" href="https://docs.angularjs.org/api/ng/directive/ngForm">ng:form</a>.'
		,
			label: 'Useful if your application is wrapped with a global form tag.'
		]
	,
		label: 'httpBackend[dev|prod]'
		info:  '@type boolean, @default false'
		items: [
			label: 'Set to true to enable httpBackend.'
		,
			label: 'This will load angular module \'ngMockE2E\'.'
		,
			label: 'Dev option applies to default and dev builds.'
		,
			label: 'Prod option applies to prod build.'
		]
	,
		label: 'httpBackend.dir'
		info:  '@type string, @default \'mocks\''
		items: [
			label: 'Directory for your client-side mock data.'
		,
			label: 'Value must be a path relative to your client directory.'
		]
	,
		label: 'templateCache.dev'
		info:  '@type boolean, @default false'
		items: [
			label: 'Set to true to use angular\'s template cache to serve views.'
		]
	,
		label: 'templateCache.urlPrefix'
		info:  '@type string'
		items: [
			label: 'Prefix for template urls.'
		]
	,
		label: 'templateCache.useAbsolutePaths'
		info:  '@type boolean, @default false'
		items: [
			label: 'Prefix template urls with a \'/\'.'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				angular: {
					version: '1.5.x',
					modulelabel: 'rapid-build',
					modules: ['ngAnimate'],
					bootstrap: true,
					ngFormify: true,
					httpBackend: {
						dev: true,
						prod: true,
						dir: 'backendless'
					},
					templateCache: {
						dev: true,
						urlPrefix: 'rapid-build',
						useAbsolutePaths: true
					}
				}
			}
		"""
, # =================================================================
	label: 'browser'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: 'open'
		info:  '@type boolean, @default true'
		items: [
			label: 'Open the browser once the build completes.'
		]
	,
		label: 'reload'
		info:  '@type boolean, @default true'
		items: [
			label: 'Reloads the browser once you save your src file.'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				browser: {
					open: false,
					reload: false
				}
			}
		"""
, # =================================================================
	label: 'build'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: 'client <small class="sep">|</small> server'
		info:  '@type boolean, @default true'
		items: [
			label: 'Set to false to skip building the client or server.'
		,
			icon:  'fa-exclamation-circle'
			label: 'Atleast one must be true.'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				build: {
					client: false,
					server: false
				}
			}
		"""
, # =================================================================
	label: 'compile'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: 'typescript[client|server].enable'
		info:  '@type boolean, @default false'
		items: [
			label: 'Set to true to enable client and or server typescript compiler.'
		,
			label: 'Place client typescript files in src/client/scripts/ directory.'
			icon:  'fa-exclamation-circle'
		,
			label: 'Place server typescript files in src/server/ directory.'
			icon:  'fa-exclamation-circle'
		]
	,
		label: 'typescript.client.entries'
		info:  '@type array of strings, @default [\'main.ts\']'
		items: [
			label: 'Entry point(s) of your app.'
			icon:  'fa-exclamation-circle'
			items: [
				label: 'This file(s) is required.'
			,
				label: 'File path(s) must be relative to scripts directory.'
			]
		,
			label: '<a target="_blank" href="http://browserify.org/">Browserify</a>
					is used for module loading.'
		,
			label: 'Must use commonjs for typescript\'s
					<a target="_blank" href="https://www.typescriptlang.org/docs/handbook/compiler-options.html">module code generation</a>.'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				compile: {
					typescript: {
						client: {
							enable: true,
							entries: ['init.ts']
						},
						server: {
							enable: true
						}
					}
				}
			}
		"""
, # =================================================================
	label: 'dist'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: 'dir'
		info:  '@type string, @default \'dist\''
		items: [
			label: 'Provide to name the dist/ directory differently.'
		]
	,
		label: 'client.dir'
		info:  '@type string, @default \'client\''
		items: [
			label: 'Provide to name the dist/client/ directory differently.'
		]
	,
		label: 'client.bower.dir'
		info:  '@type string, @default \'bower_components\''
		items: [
			label: 'Provide to name the dist/client/bower_components/ directory differently.'
		]
	,
		label: 'client.libs.dir'
		info:  '@type string, @default \'libs\''
		items: [
			label: 'Provide to name the dist/client/libs/ directory differently.'
		,
			label: 'Directory for 3rd party libraries that aren\'t bower components.'
		]
	,
		label: 'client[images|scripts|styles|test|views].dir'
		info:  '@type string, @default property name'
		items: [
			label: 'Provide to name the dist/client/property name/ directory differently.'
		,
			label: 'Property name example, \'scripts\''
		]
	,
		label: 'client.paths.absolute'
		info:  '@type boolean, @default true'
		items: [
			label: 'Set to false to create relative urls.'
		,
			label: 'By default, the build creates
					<a target="_blank" href="https://goo.gl/jK1i0L">urls absolute</a>
					to the root of your domain for:'
			items: [
				label: 'link tag\'s href attribute'
				info: 'for stylesheets'
			,
				label: 'script tag\'s src attribute'
			,
				label: 'and changes urls in css to absolute'
			]
		]
	,
		label: 'server.dir'
		info:  '@type string, @default \'server\''
		items: [
			label: 'Provide to name the dist/server/ directory differently.'
		]
	,
		label: 'server.test.dir'
		info:  '@type string, @default \'test\''
		items: [
			label: 'Provide to name the dist/server/test/ directory differently.'
		]
	,
		label: 'server.fileName'
		info:  '@type string, @default \'routes.js\''
		items: [
			label: 'This is the server\'s entry script.'
		,
			label: 'Provide if your server\'s entry script isn\'t \'routes.js\''
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				dist: {
					dir: 'pkg',
					client: {
						dir: 'frontend',
						bower:   { dir: 'bower' },
						libs:    { dir: 'libraries' },
						images:  { dir: 'img' },
						scripts: { dir: 'js' },
						styles:  { dir: 'css' },
						test:    { dir: 'tests' },
						views:   { dir: 'html' },
						paths:   { absolute: false }
					},
					server: {
						dir: 'backend',
						test: { dir: 'tests' },
						fileName: 'app.js'
					}
				}
			}
		"""
, # =================================================================
	label: 'exclude'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: 'spa'
		info:  '@type boolean, @default false'
		items: [
			label: 'Set to true to exclude spa.html from dist/client/'
		]
	,
		label: 'angular.files'
		info:  '@type boolean, @default false'
		items: [
			label: 'Set to true to exclude the angular files
					from dist/client/ that come with rapid-build.'
		,
			label: 'Includes: angular lib, angular
					<a href="#angular.modules" rb-scroll>modules</a>
					and angular <a href="#angular.bootstrap" rb-scroll>bootstrap</a>
					<em class="sub parens">if set</em>.'
		]
	,
		label: 'angular.modules'
		info:  '@type boolean, @default false'
		items: [
			label: 'Set to true to exclude injecting the
					angular <a href="#angular.modules" rb-scroll>modules</a>
					that come with rapid-build.'
		]
	,
		label: 'default[client|server].files'
		info:  '@type boolean, @default false'
		items: [
			label: 'Set to true to exclude the
					client or server files rapid-build
					sends to the dist/client/ or dist/server/
					directory.'
		]
	,
		label: 'from.cacheBust'
		info:  '@type array of strings'
		items: [
			label: 'Array of file paths.'
		,
			label: 'Files to exclude from the client-side cache bust.'
		,
			icon:  'fa-exclamation-circle'
			label: 'File paths must be relative to the dist/client/ directory.'
		]
	,
		label: 'from.dist[client|server]'
		info:  '@type array of strings'
		items: [
			label: 'Array of file paths.'
		,
			label: 'Client or server files to exclude
					from dist/client/ or dist/server/
					directory.'
		,
			icon:  'fa-exclamation-circle'
			label: 'File paths must be relative to the src/client/
					or src/server/ directory.'
		]
	,
		label: 'from.minFile[scripts|styles]'
		info:  '@type array of strings'
		items: [
			label: 'Array of file paths.'
		,
			label: 'Script or style files to exclude from
					scripts.min.js or styles.min.css file.'
		,
			icon:  'fa-exclamation-circle'
			label: 'File paths must be relative to the dist/client/ directory.'
		]
	,
		label: 'from.spaFile[scripts|styles]'
		info:  '@type array of strings'
		items: [
			label: 'Array of file paths.'
		,
			label: 'Script or style files to exclude from
					the spa.html file.'
		,
			icon:  'fa-exclamation-circle'
			label: 'File paths must be relative to the dist/client/ directory.'
		]
	,
		label: 'from.spaFile.angular.files'
		info:  '@type boolean, @default false'
		items: [
			label: 'Set to true to exclude the angular files
					from spa.html that come with rapid-build.'
		,
			label: 'Includes: angular lib and angular
					<a href="#angular.modules" rb-scroll>modules</a>.'
		]
	]
	,
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				exclude: {
					spa: true,
					angular: {
						files: true,
						modules: true
					},
					default: {
						client: {
							files: true
						},
						server: {
							files: true
						}
					},
					from: {
						cacheBust: ['images/superheroes/*'],
						dist: {
							client: ['bower_components/bootstrap/less/bootstrap.less'],
							server: ['data/superheroes.json']
						},
						minFile: {
							scripts: ['scripts/ie/ie10.js'],
							styles: ['styles/ie/ie10.css']
						}
						spaFile: {
							scripts: ['scripts/ie/ie10.js'],
							styles: ['styles/ie/ie10.css'],
							angular: {
								files: true
							}
						}
					}
				}
			}
		"""
, # =================================================================
	label: 'extra'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: 'compile.client[coffee|es6|less|sass]'
		info:  '@type array of strings'
		items: [
			label: 'Array of file paths.'
		,
			label: 'Additional files to compile to dist/client/
					directory that the build didn\'t compile.'
		,
			icon:  'fa-exclamation-circle'
			label: 'File paths must be relative to the
					src/client/ directory.'
		]
	,
		label: 'compile.server[less|sass]'
		info:  '@type array of strings'
		items: [
			label: 'Array of file paths.'
		,
			label: 'Additional files to compile to dist/server/
					directory that the build didn\'t compile.'
		,
			icon:  'fa-exclamation-circle'
			label: 'File paths must be relative to the
					src/server/ directory.'
		]
	,
		label: 'copy[client|server]'
		info:  '@type array of strings'
		items: [
			label: 'Array of file paths.'
		,
			label: 'Additional files to copy to
					dist/client/ and or dist/server/
					directory that the build didn\'t copy.'
		,
			icon:  'fa-exclamation-circle'
			label: 'File paths must be relative to the
					src/client/ or src/server/ directory.'
		]
	,
		label: 'minify.client[css|js]'
		info:  '@type array of strings'
		items: [
			label: 'Array of file paths.'
		,
			label: 'Additional files to minify in dist/client/
					directory that the build didn\'t minify.'
		,
			icon:  'fa-exclamation-circle'
			label: 'By default, the build does not minify
					files in libs or bower_components directories.'
		,
			icon:  'fa-exclamation-circle'
			label: 'File paths must be relative to the
					dist/client/ or dist/server/ directory.'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				extra: {
					compile: {
						client: {
							coffee: ['libs/coffee/utilities.coffee'],
							es6: ['libs/es6/utilities.es6'],
							less: ['bower_components/bootstrap/less/bootstrap.less'],
							sass: ['libs/sass/utilities.scss']
						},
						server: {
							less: ['misc/styles.less'],
							sass: ['misc/styles.scss']
						}
					},
					copy: {
						client: ['bower_components/bootstrap/dist/fonts/**'],
						server: ['notes.txt']
					},
					minify: {
						client: {
							css: ['bower_components/bootstrap/less/bootstrap.css'],
							js: ['libs/utilities/strings.js']
						}
					}
				}
			}
		"""
, # =================================================================
	label: 'httpProxy'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		info: "@type array of objects"
		items: [
			label: 'Object format:
					{ context: array or string, options: object }'
		,
			label: 'Useful for testing real api data instead of fake data.'
		,
			label: 'For details
					<a target="_blank" href="https://git.io/vVyA0">click here</a>.'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				httpProxy: [{
					context: '/api',
					options: {
						target: 'http://localhost:3003/'
					}
				}]
			}
		"""
, # =================================================================
	label: 'minify'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: 'cacheBust'
		info:  '@type boolean, @default true'
		items: [
			label: 'Ensures viewers of your app
					will always receive the latest client files.'
		,
			label: 'Adds an md5 checksum to the client files
					before their extension.'
		,
			label: 'Cache busted file types are: css, js, gif, jpg, jpeg and png'
		]
	,
		label: 'css.fileName'
		info:  '@type string, @default \'styles.min.css\''
		items: [
			label: 'Provide to name the minified css file differently.'
		]
	,
		label: 'css.splitMinFile'
		info:  '@type boolean, @default true'
		items: [
			label: 'Split styles.min.css into multiple files
					if the selector count > 4,095'
		,
			label: 'Useful if you have many css selectors
					and have to support ie 8 and 9.'
		,
			label: 'For details
					<a target="_blank" href="http://blesscss.com/">click here</a>.'
		]
	,
		label: 'css.styles'
		info:  '@type boolean, @default true'
		items: [
			label: 'Set to false to not minify your css files.'
		]
	,
		label: 'html.options'
		info:  '@type object, @default see below'
		items: [
			label: 'Defaults to:
					{ collapseWhitespace: true,
					removeComments: true,
					removeEmptyElements: false,
					removeEmptyAttributes: false }'
		,
			label: 'For details
					<a target="_blank" href="https://git.io/vVyAC">click here</a>.'
		]
	,
		label: 'html.views'
		info:  '@type boolean, @default true'
		items: [
			label: 'Set to false to not minify your html files.'
		]
	,
		label: 'html.templateCache'
		info:  '@type boolean, @default true'
		items: [
			label: 'Set to false to not use angular\'s
					template cache for your html files.'
		]
	,
		label: 'js.fileName'
		info:  '@type string, @default \'scripts.min.js\''
		items: [
			label: 'Provide to name the minified js file differently.'
		]
	,
		label: 'js.mangle'
		info:  '@type boolean, @default true'
		items: [
			label: 'Set to false to not mangle your js files.'
		,
			label: 'For details
					<a target="_blank" href="http://lisperator.net/uglifyjs/mangle">click here</a>.'
		]
	,
		label: 'js.scripts'
		info:  '@type boolean, @default true'
		items: [
			label: 'Set to false to not minify your js files.'
		]
	,
		label: 'spa.file'
		info:  '@type boolean, @default true'
		items: [
			label: 'Set to false to not minify your spa.html file.'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				minify: {
					cacheBust: false,
					css: {
						fileName: 'rapid-build.min.css',
						splitM inFile: false,
						styles: false
					},
					html: {
						templateCache: false,
						views: false,
						options: {
							removeComments: true
						}
					},
					js: {
						fileName: 'rapid-build.min.js',
						mangle : false,
						scripts: false
					},
					spa: {
						file: false
					}
				}
			}
	"""
, # =================================================================
	label: 'order'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: '[scripts|styles][first|last]'
		info:  '@type array of strings'
		items: [
			label: 'Array of file paths to css or js files.'
		,
			label: 'Use first to load specific scripts or styles first.'
		,
			label: 'Use last to load specific scripts or styles last.'
		,
			icon:  'fa-exclamation-circle'
			label: 'File paths must be relative to the dist/client/ directory.'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				order: {
					scripts: {
						first: ['scripts/bootstrap.js'],
						last: ['scripts/init.js']
					},
					styles: {
						first: ['styles/reset.css'],
						last: ['styles/utilities.css']
					}
				}
			}
		"""
, # =================================================================
	label: 'ports'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: 'reload'
		info:  '@type int, @default 3001'
		items: [
			label: 'Browsersync server port.'
		]
	,
		label: 'reloadUI'
		info:  '@type int, @default 3002'
		items: [
			label: 'Browsersync\'s user-interface server port.'
		]
	,
		label: 'server'
		info:  '@type int, @default 3000'
		items: [
			label: 'Web server port.'
		]
	,
		label: 'test'
		info:  '@type int, @default 9876'
		items: [
			label: 'Karma server port.'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				ports: {
					reload: 5002,
					reloadUI: 5003,
					server: 5000,
					test: 5004
				}
			}
		"""
, # =================================================================
	label: 'security'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: 'client.clickjacking'
		info:  '@type boolean, @default true'
		items: [
			label: 'The build will include a
					<a target="_blank" href="https://www.owasp.org/index.php/Clickjacking">clickjacking</a>
					defense script in the your spa.html (set to false to disable).'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				security: {
					client: {
						clickjacking: false
					}
				}
			}
		"""
, # =================================================================
	label: 'server'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: 'node_modules'
		info:  '@type array of strings'
		items: [
			label: 'Node modules to copy to dist/server/node_modules/'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				server: {
					node_modules: ['cors']
				}
			}
		"""
, # =================================================================
	label: 'spa'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: 'autoInject'
		info:  '@type array of strings, @default [\'all\']'
		items: [
			label: 'The build will automatically
					inject the following into your spa.html:'
			items: [
				label: '<a href="#security.client.clickjacking" rb-scroll>clickjacking</a>'
			,
				label: '<a href="#angular.moduleName" rb-scroll>moduleName</a>'
				info:  'ng-app attribute'
			,
				label: '<a target="_blank" href="https://docs.angularjs.org/api/ng/directive/ngCloak">ngCloakStyles</a>'
			,
				label: 'scripts'
				info:  'all your js files'
			,
				label: 'styles'
				info:  'all your css files'
			]
		,
			label: 'Or provide to the array the options you want.'
		,
			icon:  'fa-exclamation-circle'
			label: 'Disable auto injection by setting to false <em class="sub parens">boolean</em>.'
		]
	,
		label: 'description'
		info:  '@type string, @default package.json description'
		items: [
			label: 'Default spa.html meta description tag value.'
		]
	,
		label: 'placeholders'
		info:  '@type array of strings'
		items: [
			label: 'Retain spa.html file placeholders.'
		,
			label: 'Options include <em class="sub parens">all or individuals</em>:'
			items: [
				label: 'all'
			,
				label: 'clickjacking, description, moduleName,
						ngCloakStyles, scripts, styles and title'
			]
		]
	,
		label: 'title'
		info:  '@type string, @default package.json name or \'Application\''
		items: [
			label: 'Default spa.html title tag value.'
		]
	,
		label: 'dist.fileName'
		info:  '@type string, @default file name of spa.src.filePath or \'spa.html\''
		items: [
			label: 'Provide to name dist/client/spa.html file differently.'
		,
			label: 'Example: \'index.html\''
		]
	,
		label: 'src.filePath'
		info:  '@type string'
		items: [
			label: 'Provide to use your own spa.html
					file and not the build\'s default spa.html.'
		,
			icon:  'fa-exclamation-circle'
			label: 'File must be located in the src/client/ directory.'
		,
			icon:  'fa-exclamation-circle'
			label: 'File path must be relative to the src/client/ directory.'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				spa: {
					autoInject: false,
					description: 'Documentation website for rapid-build.',
					placeholders: ['all'],
					title: 'Rapid Build',
					dist: {
						fileName: 'index.html'
					},
					src: {
						filePath: 'spa.html'
					}
				}
			}
		"""
, # =================================================================
	label: 'src'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: 'dir'
		info:  '@type string, @default \'src\''
		items: [
			label: 'Provide to name the src/ directory differently.'
		]
	,
		label: 'client.dir'
		info:  '@type string, @default \'client\''
		items: [
			label: 'Provide to name the src/client/ directory differently.'
		]
	,
		label: 'client.bower.dir'
		info:  '@type string, @default \'bower_components\''
		items: [
			label: 'Provide to name the src/client/bower_components/
					directory differently.'
		]
	,
		label: 'client.libs.dir'
		info:  '@type string, @default \'libs\''
		items: [
			label: 'Provide to name the src/client/libs/
					directory differently.'
		,
			label: 'Directory for 3rd party libraries
					that aren\'t bower components.'
		]
	,
		label: 'client[images|scripts|styles|test|views].dir'
		info:  '@type string, @default property name'
		items: [
			label: 'Provide to name the src/client/property name/
					directory differently.'
		,
			label: 'Property name example, \'scripts\''
		]
	,
		label: 'server.dir'
		info:  '@type string, @default \'server\''
		items: [
			label: 'Provide to name the src/server/ directory differently.'
		]
	,
		label: 'server.test.dir'
		info:  '@type string, @default \'test\''
		items: [
			label: 'Provide to name the src/server/test/
					directory differently.'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				dist: {
					dir: 'source',
					client: {
						dir: 'frontend',
						bower:   { dir: 'bower' },
						libs:    { dir: 'libraries' },
						images:  { dir: 'img' },
						scripts: { dir: 'js' },
						styles:  { dir: 'css' },
						test:    { dir: 'tests' },
						views:   { dir: 'html' }
					},
					server: {
						dir: 'backend',
						test: { dir: 'tests' }
					}
				}
			}
		"""
, # =================================================================
	label: 'test'
	icon:  'fa-cog'
	html:
		class: items2: list: 'small'
	items: [
		label: 'client.browsers'
		info:  '@type array of strings'
		items: [
			label: 'Array of browser names.'
		,
			label: 'Phantomjs will run by default.'
		]
	]
	example:
		label: 'Example'
		info:  '<a href="/getting-started#rapid-build.json">for rapid-build.json</a>'
		lang:  'js'
		size:  'small'
		code:  """
			{
				test: {
					client: {
						browsers: ['chrome', 'firefox', 'ie', 'safari']
					}
				}
			}
		"""
]










