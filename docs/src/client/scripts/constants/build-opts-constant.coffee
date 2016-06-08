angular.module('rapid-build').constant 'BUILD_OPTS',
	angular:
		info: 'for angular 1.x'
		opts: [
			name: 'version'
			info: "@type string, @default '1.x'"
			description: [
				"The version of angular to load."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 Currently the build does not support angular 2
				 out of the box."
			]
		,
			name: 'moduleName'
			info: "@type string, @default 'app'"
			description: [
				'Application module name.'
			,
				'Value for ng-app in
				<a href="#spa" rb-scroll>spa.html</a> or angular\'s
				<a href="#angular.bootstrap" rb-scroll> bootstrap</a>.'
			]
		,
			name: 'modules'
			info: "@type array of strings"
			description: [
				"Additional angular modules to load."
				"By default the build loads
				 ['ngResource', 'ngRoute', 'ngSanitize']
				 and 'ngMockE2E' based on
				 angular.<a href=\"#angular.httpBackend[dev|prod]\" rb-scroll>httpBackend</a>
				 options."
			]
		,
			name: 'bootstrap'
			info: "@type boolean or string, @default false"
			description: [
				'By default the build initializes angular via
				 <a target="_blank" href="https://docs.angularjs.org/guide/bootstrap">ng-app</a>
				 in <a href="#spa" rb-scroll>spa.html</a>.'
				'Provide true to use angular\'s
				 <a target="_blank" href="https://docs.angularjs.org/guide/bootstrap#manual-initialization">bootstrap</a>
				 method instead.
				 <ul>
					<li>
						The build will bootstrap on the document.
					</li>
				 </ul>'
				'Or provide a
				 <a target="_blank" href="https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector">css selector</a>
				 <em class="sub parens">string</em> to the dom element to bootstrap.'
				'The bootstrap script will load last.'
			]
		,
			name: 'ngFormify'
			info: "@type boolean, @default false"
			description: [
				"Set to true to replace all html form tags with
				 <a target=\"_blank\" href=\"https://docs.angularjs.org/api/ng/directive/ngForm\">ng:form</a>."
				"Useful if your application is wrapped with a global form tag."
			]
		,
			name: 'httpBackend[dev|prod]'
			info: "@type boolean, @default false"
			description: [
				"Set to true to enable httpBackend."
				"This will load angular module 'ngMockE2E'."
				"Dev option applies to default and dev builds."
				"Prod option applies to prod build."
			]
		,
			name: 'httpBackend.dir'
			info: "@type string, @default 'mocks'"
			description: [
				"Directory for your client-side mock data."
				"Value must be a path relative to your client directory."
			]
		,
			name: 'templateCache.dev'
			builds: 'default and dev'
			info: "@type boolean, @default false"
			description: [
				"Set to true to use angular's template cache to serve views."
			]
		,
			name: 'templateCache.urlPrefix'
			info: "@type string"
			description: [
				"Prefix for template urls."
			]
		,
			name: 'templateCache.useAbsolutePaths'
			info: "@type boolean, @default false"
			description: [
				"Prefix template urls with a '/'."
			]
		]
		example: """
			{
				angular: {
					version: '1.5.x',
					moduleName: 'rapid-build',
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

	browser:
		opts: [
			name: 'open'
			info: "@type boolean, @default true"
			builds: 'default, dev and prod:server'
			description: [
				"Open the browser once the build completes."
			]
		,
			name: 'reload'
			info: "@type boolean, @default true"
			builds: 'dev'
			description: [
				"Reloads the browser once you save your src file."
			]
		]
		example: """
			var opts = {
				browser: {
					open: false,
					reload: false
				}
			}
		"""

	build:
		opts: [
			name: 'client <small class="sep">|</small> server'
			info: "@type boolean, @default true"
			description: [
				"Set to false to skip building the client or server."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 Atleast one must be true."
			]
		]
		example: """
			{
				build: {
					client: false,
					server: false
				}
			}
		"""

	browser:
		opts: [
			name: 'open'
			info: "@type boolean, @default true"
			builds: 'default, dev and prod:server'
			description: [
				"Open the browser once the build completes."
			]
		,
			name: 'reload'
			info: "@type boolean, @default true"
			builds: 'dev'
			description: [
				"Reloads the browser once you save your src file."
			]
		]
		example: """
			{
				browser: {
					open: false,
					reload: false
				}
			}
		"""

	dist:
		opts: [
			name: 'dir'
			info: "@type string, @default 'dist'"
			description: [
				"Provide to name the dist/ directory differently."
			]
		,
			name: 'client.dir'
			info: "@type string, @default 'client'"
			description: [
				"Provide to name the dist/client/ directory differently."
			]
		,
			name: 'client.bower.dir'
			info: "@type string, @default 'bower_components'"
			description: [
				"Provide to name the dist/client/bower_components/
				 directory differently."
			]
		,
			name: 'client.libs.dir'
			info: "@type string, @default 'libs'"
			description: [
				"Provide to name the dist/client/libs/
				 directory differently."
				"Directory for 3rd party libraries
				 that aren't bower components."
			]
		,
			name: 'client[images|scripts|styles|test|views].dir'
			info: "@type string, @default property name"
			description: [
				"Provide to name the dist/client/property name/
				 directory differently."
				"Property name example, 'scripts'"
			]
		,
			name: 'server.dir'
			info: "@type string, @default 'server'"
			description: [
				"Provide to name the dist/server/ directory differently."
			]
		,
			name: 'server.test.dir'
			info: "@type string, @default 'test'"
			description: [
				"Provide to name the dist/server/test/
				 directory differently."
			]
		,
			name: 'server.fileName'
			info: "@type string, @default 'routes.js'"
			description: [
				"This is the server's entry script."
				"Provide if your server's entry script isn't 'routes.js'"
			]
		]
		example: """
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
						views:   { dir: 'html' }
					},
					server: {
						dir: 'backend',
						test: { dir: 'tests' },
						fileName: 'app.js'
					}
				}
			}
		"""

	exclude:
		opts: [
			name: 'spa'
			info: "@type boolean, @default false"
			description: [
				"Set to true to exclude spa.html from dist/client/"
			]
		,
			name: 'angular.files'
			info: "@type boolean, @default false"
			description: [
				"Set to true to exclude the angular files
				 from dist/client/ that come with rapid-build."
				"Includes: angular lib, angular
				 <a href=\"#angular.modules\" rb-scroll>modules</a>
				 and angular <a href=\"#angular.bootstrap\" rb-scroll>bootstrap</a>
				 <em class=\"sub parens\">if set</em>."
			]
		,
			name: 'angular.modules'
			info: "@type boolean, @default false"
			description: [
				"Set to true to exclude injecting the
				 angular <a href=\"#angular.modules\" rb-scroll>modules</a>
				 that come with rapid-build."
			]
		,
			name: 'default[client|server].files'
			info: "@type boolean, @default false"
			description: [
				"Set to true to exclude the
				 client or server files rapid-build
				 sends to the dist/client/ or dist/server/
				 directory."
			]
		,
			name: 'from.cacheBust'
			info: "@type array of strings"
			description: [
				"Array of file paths."
				"Files to exclude from the client-side cache bust."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File paths must be relative to the dist/client/ directory."
			]
		,
			name: 'from.dist[client|server]'
			info: "@type array of strings"
			description: [
				"Array of file paths."
				"Client or server files to exclude
				 from dist/client/ or dist/server/
				 directory."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File paths must be relative to the src/client/
				 or src/server/ directory."
			]
		,
			name: 'from.minFile[scripts|styles]'
			info: "@type array of strings"
			description: [
				"Array of file paths."
				"Script or style files to exclude from
				 scripts.min.js or styles.min.css file."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File paths must be relative to the dist/client/ directory."
			]
		,
			name: 'from.spaFile[scripts|styles]'
			info: "@type array of strings"
			description: [
				"Array of file paths."
				"Script or style files to exclude from
				 the spa.html file."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File paths must be relative to the dist/client/ directory."
			]
		]
		example: """
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
							scripts: ['ie/ie10.js'],
							styles: ['ie/ie10.css']
						}
						spa: {
							scripts: ['ie/ie10.js'],
							styles: ['ie/ie10.css']
						}
					}
				}
			}
		"""

	extra:
		opts: [
			name: 'compile.client[coffee|es6|less|sass]'
			info: "@type array of strings"
			description: [
				"Array of file paths."
				"Additional files to compile to dist/client/
				 directory that the build didn't compile."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File paths must be relative to the
				 src/client/ directory."
			]
		,
			name: 'compile.server[less|sass]'
			info: "@type array of strings"
			description: [
				"Array of file paths."
				"Additional files to compile to dist/server/
				 directory that the build didn't compile."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File paths must be relative to the
				 src/server/ directory."
			]
		,
			name: 'copy[client|server]'
			info: "@type array of strings"
			description: [
				"Array of file paths."
				"Additional files to copy to
				 dist/client/ and or dist/server/
				 directory that the build didn't copy."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File paths must be relative to the
				 src/client/ or src/server/ directory."
			]
		,
			name: 'minify.client[css|js]'
			info: "@type array of strings"
			description: [
				"Array of file paths."
				"Additional files to minify in dist/client/
				 directory that the build didn't minify."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 By default, the build does not minify
				 files in libs or bower_components directories."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File paths must be relative to the
				 dist/client/ or dist/server/ directory."
			]
		]
		example: """
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

	httpProxy:
		opts: [
			info: "@type array of objects"
			description: [
				"Object format:
				 { context: array or string, options: object }"
				"Useful for testing real api data instead of fake data."
				"For details
				 <a target=\"_blank\" href=\"https://git.io/vVyA0\">click here</a>."
			]
		]
		example: """
			{
				httpProxy: [{
					context: '/api',
					options: {
						target: 'http://localhost:3003/'
					}
				}]
			}
		"""

	minify:
		opts: [
			name: 'cacheBust'
			info: "@type boolean, @default true"
			description: [
				"Ensures viewers of your app
				 will always receive the latest client files."
				"Adds an md5 checksum to the client files
				 before their extension."
				"Cache busted file types are: css, js, gif, jpg, jpeg and png"
			]
		,
			name: 'css.fileName'
			info: "@type string, @default 'styles.min.css'"
			description: [
				"Provide to name the minified css file differently."
			]
		,
			name: 'css.splitMinFile'
			info: "@type boolean, @default true"
			description: [
				"Split styles.min.css into multiple files
				 if the selector count > 4,095"
				"Useful if you have many css selectors
				 and have to support ie 8 and 9."
				"For details
				 <a target=\"_blank\" href=\"http://blesscss.com/\">click here</a>."
			]
		,
			name: 'css.styles'
			info: "@type boolean, @default true"
			description: [
				"Set to false to not minify your css files."
			]
		,
			name: 'html.options'
			info: "@type object, @default see below"
			description: [
				"Defaults to:
				 { collapseWhitespace: true,
				   removeComments: true,
				   removeEmptyElements: false,
				   removeEmptyAttributes: false }"
				"For details
				 <a target=\"_blank\" href=\"https://git.io/vVyAC\">click here</a>."
			]
		,
			name: 'html.views'
			info: "@type boolean, @default true"
			description: [
				"Set to false to not minify your html files."
			]
		,
			name: 'html.templateCache'
			info: "@type boolean, @default true"
			description: [
				"Set to false to not use angular's
				 template cache for your html files."
			]
		,
			name: 'js.fileName'
			info: "@type string, @default 'scripts.min.js'"
			description: [
				"Provide to name the minified js file differently."
			]
		,
			name: 'js.mangle'
			info: "@type boolean, @default true"
			description: [
				"Set to false to not mangle your js files."
				"For details
				 <a target=\"_blank\" href=\"http://lisperator.net/uglifyjs/mangle\">click here</a>."
			]
		,
			name: 'js.scripts'
			info: "@type boolean, @default true"
			description: [
				"Set to false to not minify your js files."
			]
		,
			name: 'spa.file'
			info: "@type boolean, @default true"
			description: [
				"Set to false to not minify your spa.html file."
			]
		]
		example: """
			{
				minify: {
					cacheBust: false,
					css: {
						fileName: 'rapid-build.min.css',
						splitMinFile: false,
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
						mangle: false,
						scripts: false
					},
					spa: {
						file: false
					}
				}
			}
		"""

	order:
		opts: [
			name: '[scripts|styles][first|last]'
			info: "@type array of strings"
			description: [
				"Array of file paths to css or js files."
				"Use first to load specific scripts or styles first."
				"Use last to load specific scripts or styles last."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File paths must be relative to the dist/client/ directory."
			]
		]
		example: """
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

	ports:
		opts: [
			name: 'reload'
			info: "@type int, @default 3001"
			builds: 'dev'
			description: [
				"Browsersync server port."
			]
		,
			name: 'reloadUI'
			info: "@type int, @default 3002"
			builds: 'dev'
			description: [
				"Browsersync's user-interface server port."
			]
		,
			name: 'server'
			info: "@type int, @default 3000"
			description: [
				"Web server port."
			]
		,
			name: 'test'
			info: "@type int, @default 9876"
			builds: 'test'
			description: [
				"Karma server port."
			]
		]
		example: """
			{
				ports: {
					reload: 5002,
					reloadUI: 5003,
					server: 5000,
					test: 5004
				}
			}
		"""

	security:
		opts: [
			name: 'client.clickjacking'
			info: "@type boolean, @default true"
			description: [
				"The build will include a
				 <a target=\"_blank\" href=\"https://www.owasp.org/index.php/Clickjacking\">clickjacking</a>
				 defense script in the your spa.html (set to false to disable)."
			]
		]
		example: """
			{
				security: {
					client: {
						clickjacking: false
					}
				}
			}
		"""

	server:
		opts: [
			name: 'node_modules'
			info: "@type array of strings"
			description: [
				"Node modules to copy to dist/server/node_modules/"
			]
		]
		example: """
			{
				server: {
					node_modules: ['cors']
				}
			}
		"""

	spa:
		opts: [
			name: 'autoInject'
			info: "@type array of strings, @default ['all']"
			description: [
				"The build will automatically
				 inject the following into your spa.html:
				 <ul>
					<li>
						<a href=\"#security.client.clickjacking\" rb-scroll>clickjacking</a>
					</li>
					<li>
						<a href=\"#angular.moduleName\" rb-scroll>moduleName</a>
						<em class=\"sub sep parens\">ng-app attribute</em>
					</li>
					<li>
						<a target=\"_blank\" href=\"https://docs.angularjs.org/api/ng/directive/ngCloak\">ngCloakStyles</a>
					</li>
					<li>
						scripts <em class=\"sub sep parens\">all your js files</em>
					</li>
					<li>
						styles <em class=\"sub sep parens\">all your css files</em>
					</li>
				 </ul>
				"
				"Or provide to the array the options you want."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 Disable auto injection by setting to false <em class=\"sub parens\">boolean</em>."
			]
		,
			name: 'description'
			info: "@type string, @default package.json description"
			description: [
				"Default spa.html meta description tag value."
			]
		,
			name: 'placeholders'
			info: "@type array of strings"
			description: [
				"Retain spa.html file placeholders.",
				"Options include <em class=\"sub parens\">all or individuals</em>:
				<ul>
					<li>
						all
					</li>
					<li>
						clickjacking, description, moduleName,
						ngCloakStyles, scripts, styles and title
					</li>
				</ul>"
			]
		,
			name: 'title'
			info: "@type string, @default package.json name or 'Application'"
			description: [
				"Default spa.html title tag value."
			]
		,
			name: 'dist.fileName'
			info: "@type string, @default file name of spa.src.filePath or 'spa.html'"
			description: [
				"Provide to name dist/client/spa.html file differently."
				"Example: 'index.html'"
			]
		,
			name: 'src.filePath'
			info: "@type string"
			description: [
				"Provide to use your own spa.html
				 file and not the build's default spa.html."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File must be located in the src/client/ directory."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File path must be relative to the src/client/ directory."
			]
		]
		example: """
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

	src:
		opts: [
			name: 'dir'
			info: "@type string, @default 'src'"
			description: [
				"Provide to name the src/ directory differently."
			]
		,
			name: 'client.dir'
			info: "@type string, @default 'client'"
			description: [
				"Provide to name the src/client/ directory differently."
			]
		,
			name: 'client.bower.dir'
			info: "@type string, @default 'bower_components'"
			description: [
				"Provide to name the src/client/bower_components/
				 directory differently."
			]
		,
			name: 'client.libs.dir'
			info: "@type string, @default 'libs'"
			description: [
				"Provide to name the src/client/libs/
				 directory differently."
				"Directory for 3rd party libraries
				 that aren't bower components."
			]
		,
			name: 'client[images|scripts|styles|test|views].dir'
			info: "@type string, @default property name"
			description: [
				"Provide to name the src/client/property name/
				 directory differently."
				"Property name example, 'scripts'"
			]
		,
			name: 'server.dir'
			info: "@type string, @default 'server'"
			description: [
				"Provide to name the src/server/ directory differently."
			]
		,
			name: 'server.test.dir'
			info: "@type string, @default 'test'"
			description: [
				"Provide to name the src/server/test/
				 directory differently."
			]
		]
		example: """
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

	test:
		opts: [
			name: 'client.browsers'
			info: "@type array of strings"
			description: [
				"Array of browser names."
				"Phantomjs will run by default."
			]
		]
		example: """
			{
				test: {
					client: {
						browsers: ['chrome', 'firefox', 'ie', 'safari']
					}
				}
			}
		"""







