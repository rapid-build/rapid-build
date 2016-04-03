angular.module('rapid-build').directive 'rbSearch', [->
	# Link
	# ====
	link = (scope, element, attrs, controllers) ->
		scope.icon = 'search'

		scope.search = ->
			return unless scope.model
			scope.model = ''
			element.find('input')[0].focus()

		# watches
		# =======
		modelWatch = scope.$watch 'model', (newVal, oldVal) ->
			return scope.icon = 'search' unless newVal
			scope.icon = 'remove'

		# destroy
		# =======
		scope.$on '$destroy', ->
			modelWatch()

	# API
	# ===
	link: link
	replace: true
	templateUrl: '/views/directives/search.html'
	scope:
		align:   '@'
		caption: '@'
		kind:    '@'
		model:   '='
]



