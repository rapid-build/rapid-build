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
				element.attr 'hljs-source', scope.src if scope.src
				$compile(element) scope.$parent
				return unless lang
				return if scope.hideLang
				element.prepend "<h4 title=\"#{lang}\">#{lang}</h4>"

		# link
		# ====
		link = (scope, element, attrs, controller, transcludeFn) ->
			# defaults
			scope.hideLang    = attrs.hideLang isnt undefined
			scope.interpolate = attrs.interpolate isnt undefined

			# transclude
			transcludeFn (clone) ->
				return help.compile text, scope, element if scope.src
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
			src: '@' # = binding
			# valueless attrs:
			# hideLang:    '@'
			# interpolate: '@'
]



