angular.module('rapid-build').controller 'buildTypesController',
	['$scope', 'BUILD_COMMON_TASKS', 'BUILD_TYPES',
	($scope, BUILD_COMMON_TASKS, BUILD_TYPES) ->
		$scope.buildCommonTasks = BUILD_COMMON_TASKS
		$scope.buildTypes       = BUILD_TYPES
]