angular.module('rapid-build').constant 'BUILD_OPTS',
	angular:
		opts: [
			name: 'moduleName'
			define: "@type string, @default 'app'"
			description: [
				"Application module name, value for ng-app."
			]
		,
			name: 'modules'
			define: "@type array of strings"
			description: [
				"Additional angular modules to load."
				"By default the build loads
				['ngResource', 'ngRoute', 'ngSanitize']
				and 'ngMockE2E' based on angular.httpBackend
				options."
			]
		,
			name: 'version'
			define: "@type string, @default '1.x'"
			description: [
				"The version of angular to load."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				Currently the build does not support angular 2
				out of the box."
			]
		,
			name: 'ngFormify'
			define: "@type boolean, @default false"
			description: [
				"Set to true to replace all html form tags with
				<a target=\"_blank\" href=\"https://docs.angularjs.org/api/ng/directive/ngForm\">ng:form</a>."
				"Useful if your application is wrapped with a global form tag."
			]
		,
			name: 'httpBackend[dev|prod]'
			define: "@type boolean, @default false"
			description: [
				"Set to true to enable httpBackend."
				"This will load angular module 'ngMockE2E'."
				"Dev option applies to default and dev builds."
				"Prod option applies to prod build."
			]
		,
			name: 'httpBackend.dir'
			define: "@type string, @default 'mocks'"
			description: [
				"Directory for your client-side mock data."
				"Value must be a path relative to your client directory."
			]
		,
			name: 'templateCache.dev'
			builds: 'default and dev'
			define: "@type boolean, @default false"
			description: [
				"Set to true to use angular's template cache to serve views."
			]
		,
			name: 'templateCache.urlPrefix'
			define: "@type string"
			description: [
				"Prefix for template urls."
			]
		,
			name: 'templateCache.useAbsolutePaths'
			define: "@type boolean, @default false"
			description: [
				"Prefix template urls with a '/'."
			]
		]
		example: """
			var opts = {
				angular: {
					modules: ['ngAnimate'],
					moduleName: 'rapid-build',
					version: '1.5.x',
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
			define: "@type boolean, @default true"
			builds: 'default, dev and prod:server'
			description: [
				"Open the browser once the build completes."
			]
		,
			name: 'reload'
			define: "@type boolean, @default true"
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
			define: "@type boolean, @default true"
			description: [
				"Set to false to skip building the client or server."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				Atleast one must be true."
			]
		]
		example: """
			var opts = {
				build: {
					client: false,
					server: false
				}
			}
		"""

	browser:
		opts: [
			name: 'open'
			define: "@type boolean, @default true"
			builds: 'default, dev and prod:server'
			description: [
				"Open the browser once the build completes."
			]
		,
			name: 'reload'
			define: "@type boolean, @default true"
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

	order:
		opts: [
			name: '[scripts|styles][first|last]'
			define: "@type array of strings"
			description: [
				"Array of file paths to css or js files."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File paths must be relative to your dist/client/ directory."
				"Use first to load specific scripts or styles first."
				"Use last to load specific scripts or styles last."
			]
		]
		example: """
			var opts = {
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
			define: "@type int, @default 3001"
			builds: 'dev'
			description: [
				"Browsersync server port."
			]
		,
			name: 'reloadUI'
			define: "@type int, @default 3002"
			builds: 'dev'
			description: [
				"Browsersync's user-interface server port."
			]
		,
			name: 'server'
			define: "@type int, @default 3000"
			description: [
				"Web server port."
			]
		,
			name: 'test'
			define: "@type int, @default 9876"
			builds: 'test'
			description: [
				"Karma server port."
			]
		]
		example: """
			var opts = {
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
			define: "@type boolean, @default true"
			description: [
				"The build will include a
				<a target=\"_blank\" href=\"https://www.owasp.org/index.php/Clickjacking\">clickjacking</a>
				defense script in the default spa.html (set to false to disable)."
			]
		]
		example: """
			var opts = {
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
			define: "@type array of strings"
			description: [
				"Node modules to copy to dist/server/node_modules/"
			]
		]
		example: """
			var opts = {
				server: {
					node_modules: ['cors']
				}
			}
		"""

	spa:
		opts: [
			name: 'description'
			define: "@type string, @default package.json description"
			description: [
				"Default spa.html meta description tag value."
			]
		,
			name: 'placeholders'
			define: "@type array of strings"
			description: [
				"Retain spa.html file placeholders.",
				"Options include:
				<ul>
					<li>
						all or
					</li>
					<li>
						clickjacking, description, moduleName, scripts, styles and title
					</li>
				</ul>"
			]
		,
			name: 'title'
			define: "@type string, @default package.json name or 'Application'"
			description: [
				"Default spa.html title tag value."
			]
		,
			name: 'dist.fileName'
			define: "@type string, @default file name of spa.src.filePath or 'spa.html'"
			description: [
				"Provide to name dist/client/spa.html file differently."
				"Example: 'index.html'"
			]
		,
			name: 'src.filePath'
			define: "@type string"
			description: [
				"Provide to use your own spa.html
				file and not the build's default spa.html."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File must be located in your src/client/ directory."
				"<rb:icon kind=\"fa-exclamation-circle\"></rb:icon>
				 File path must be relative to your src/client/ directory."
			]
		]
		example: """
			var opts = {
				spa: {
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

	test:
		opts: [
			name: 'client.browsers'
			define: "@type array of strings (browser names)"
			description: [
				"Phantomjs will run by default."
			]
		]
		example: """
			var opts = {
				test: {
					client: {
						browsers: ['chrome', 'firefox', 'ie', 'safari']
					}
				}
			}
		"""







