angular.module('rapid-build').config ['$routeProvider'
	($routeProvider) ->
		$routeProvider
			.when '/',
				templateUrl: '/views/mains/home.html'
			.when '/getting-started',
				templateUrl: '/views/mains/getting-started.html'
			.otherwise
				redirectTo: '/'
]
