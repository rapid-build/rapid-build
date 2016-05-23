angular.module('rapid-build').controller 'buildTypesController', ['$scope', 'BUILD_TYPES',
	($scope, BUILD_TYPES) ->
		$scope.buildTypes = BUILD_TYPES
]