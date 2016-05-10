angular.module('rapid-build').controller 'buildOptsController', ['$scope', 'BUILD_OPTS',
	($scope, BUILD_OPTS) ->
		$scope.buildOpts = BUILD_OPTS
]