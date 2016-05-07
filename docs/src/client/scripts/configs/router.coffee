angular.module('rapid-build').config ['$routeProvider'
	($routeProvider) ->
		$routeProvider
			.when '/',
				templateUrl: '/views/mains/home.html'

			.when '/about',
				templateUrl: '/views/mains/about.html'

			.when '/getting-started',
				templateUrl: '/views/mains/getting-started.html'

			.when '/build-modes',
				templateUrl: '/views/mains/build-modes.html'

			.when '/build-options',
				templateUrl: '/views/mains/build-options.html'
				reloadOnSearch: false

			.when '/examples',
				templateUrl: '/views/mains/examples.html'

			.otherwise
				redirectTo: '/'
]
