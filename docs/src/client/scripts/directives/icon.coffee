angular.module('rapid-build').directive 'rbIcon', [->
	# Link
	# ====
	link = (scope, element, attrs, controllers) ->
		kind = scope.kind
		return unless kind

		switch true
			when kind.indexOf('fa-')  is 0 then scope.icon = 'fa '
			when kind.indexOf('ion-') is 0 then scope.icon = 'icon '
			else scope.icon = 'glyphicon glyphicon-'

		scope.icon += kind

	# API
	# ===
	link: link
	replace: true
	templateUrl: '/views/directives/icon.html'
	scope:
		kind: '@'
		size: '@'
]



