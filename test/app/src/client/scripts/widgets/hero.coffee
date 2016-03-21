angular.module('app').directive 'appHero', ['$log', ($log) ->
	replace: true
	restrict: 'E'
	templateUrl: 'views/widgets/hero.html'
	transclude: true
	scope:
		# leave off name to show all superheroes
		# name options: ironman | superman | wolverine
		name: '@'
]