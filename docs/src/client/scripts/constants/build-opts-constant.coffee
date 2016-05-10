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
			define: "@type boolean, @default false"
			description: [
				"Set to true to use angular's template cache to serve views."
				"Applies to default and dev builds."
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
			description: [
				"Open the browser once the build completes."
				"Applies to builds: default, dev and prod:server."
			]
		,
			name: 'reload'
			define: "@type boolean, @default true"
			description: [
				"Reloads the browser once you save your src file."
				"Applies to dev build."
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



