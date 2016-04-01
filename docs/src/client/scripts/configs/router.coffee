angular.module('app').config ['$routeProvider'
	($routeProvider) ->
		$routeProvider
			.when '/',
				templateUrl: '/views/mains/home.html'
			.otherwise
				redirectTo: '/'
]
