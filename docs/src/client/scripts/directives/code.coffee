angular.module('rapid-build').directive 'rbCode', ['$compile', 'preService',
	($compile, preService) ->
		# helpers
		# =======
		help =
			add:
				highlight: (text, scope, element, attrs) ->
					interpolate = attrs.interpolate isnt undefined # valueless attr
					element.text text
					element.attr 'hljs', ''
					element.attr 'hljs-interpolate', true    if interpolate
					element.attr 'hljs-language', scope.lang if scope.lang
					element.attr 'hljs-source', scope.src    if scope.src
					$compile(element) scope.$parent

				lang: (scope, element, attrs) ->
					lang = scope.lang
					return unless lang
					hideLang = attrs.hideLang # valueless attr and accepts false
					hideLang = hideLang isnt undefined and hideLang isnt 'false'
					return if hideLang
					element.prepend "<h4 title=\"#{lang}\">#{lang}</h4>"

				clipboard: (scope, element, attrs) ->
					clipboard = attrs.clipboard # valueless attr and accepts false
					clipboard = clipboard isnt undefined and clipboard isnt 'false'
					return unless clipboard
					id = "code-#{scope.$id}"
					element[0].querySelector('code').id = id

					scope.copySuccess = (e) ->
						e.clearSelection()

					element.prepend "
						<a href ngclipboard title=\"copy\"
						   ngclipboard-success=\"copySuccess(e);\"
						   data-clipboard-target=\"##{id}\">
							<rb:icon kind=\"copy\"></rb:icon>
						</a>"

					trigger = element[0].querySelector '[ngclipboard]'
					$compile(trigger) scope


			compile: (text, scope, element, attrs) ->
				@add.highlight text, scope, element, attrs
				@add.lang scope, element, attrs
				@add.clipboard scope, element, attrs


		# link
		# ====
		link = (scope, element, attrs, controller, transcludeFn) ->
			transcludeFn (clone) ->
				return help.compile text, scope, element, attrs if scope.src
				elm  = clone[0]
				return unless elm
				text = elm.textContent
				return unless text.trim()
				text = preService.get.text text
				help.compile text, scope, element, attrs

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
			# clipboard:   '@' # accepts false too
			# hideLang:    '@' # accepts false too
			# interpolate: '@'
]



