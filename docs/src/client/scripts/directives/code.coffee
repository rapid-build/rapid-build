angular.module('rapid-build').directive 'rbCode', ['$compile', 'preService',
	($compile, preService) ->
		# helpers
		# =======
		help =
			compile: (text, scope, element) ->
				lang = scope.lang
				element.text text
				element.attr 'hljs', ''
				element.attr 'hljs-language', lang if lang
				element.attr 'hljs-interpolate', true if scope.interpolate
				$compile(element) scope.$parent
				element.prepend "<h4 title=\"#{lang}\">#{lang}</h4>" if lang

		# link
		# ====
		link = (scope, element, attrs, controller, transcludeFn) ->
			# defaults
			scope.interpolate = attrs.interpolate isnt undefined

			# transclude
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
		templateUrl: '/views/directives/code.html'
		scope:
			display: '@'
			lang: '@'
			size: '@'
			# valueless attrs:
			# interpolate: '@'
]



