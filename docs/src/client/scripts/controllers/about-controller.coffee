angular.module('rapid-build').controller 'aboutController', ['$scope', 'ABOUT',
	($scope, ABOUT) ->
		$scope.about = ABOUT
]