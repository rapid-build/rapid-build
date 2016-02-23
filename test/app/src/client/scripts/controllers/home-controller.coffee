angular.module('app').controller 'homeController', ['$scope', 'superheroesValue',
	($scope, superheroes) ->
		$scope.superheroes = superheroes
]