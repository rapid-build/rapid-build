angular.module('rapid-build').directive 'rbPre', ['$compile', 'preService'
	($compile, preService) ->
		# helpers
		# =======
		help =
			compile: (text, scope, element) ->
				element.text text
				$compile(element) scope.$parent

		# link
		# ====
		link = (scope, element, attrs, controller, transcludeFn) ->
			transcludeFn (clone) ->
				elm  = clone[0]
				return unless elm
				text = elm.textContent
				return unless text.trim()
				text = preService.get.text text
				help.compile text, scope, element

		# API
		# ===
		link: link
		replace: true
		transclude: true
		templateUrl: '/views/directives/pre.html'
		scope:
			display: '@'
]



