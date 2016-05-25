angular.module('rapid-build').controller 'gettingStartedController', ['$scope', 'GETTING_STARTED',
	($scope, GETTING_STARTED) ->
		$scope.gettingStarted = GETTING_STARTED
]