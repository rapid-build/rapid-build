angular.module('app').config(['$locationProvider', '$routeProvider',
	($locationProvider, $routeProvider) => {
		/* Enable Html5 Mode
	 	 ********************/
		$locationProvider.html5Mode({
			enabled: true,
			requireBase: false
		});

		/* Angular Router
	 	 *****************/
		$routeProvider.when('/', {
			templateUrl: 'views/home.html'
		}).otherwise({
			redirectTo: '/'
		});
}]);