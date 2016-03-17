angular.module('app').directive 'appSuperhero', ['$log', ($log) ->
	replace: true
	restrict: 'E'
	templateUrl: 'views/widgets/superhero.html'
	transclude: true
	scope:
		# leave off name to show all superheroes
		# name options: ironman | superman | wolverine
		name: '@'
]