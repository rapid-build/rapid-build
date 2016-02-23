/**************************************************************
* Clarity requirement, do not delete this file!
* Define routes with their corresponding layout and views here.
* Reference:
*   http://clarity-api/#/help/routing
*   http://clarity-api/#/layouts/
***************************************************************/
angular.module('app').config(['$routeProvider', ($routeProvider) => {
	$routeProvider
		.when('/', {
			templateUrl: 'views/mains/home.html'
		})
		.otherwise({
			redirectTo: '/'
		})
}])