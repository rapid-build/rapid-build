angular.module('app').controller 'homeController', ['$scope', 'heroesValue',
	($scope, heroes) ->
		$scope.heroes = heroes
]