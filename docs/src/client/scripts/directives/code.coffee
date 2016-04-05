angular.module('rapid-build').directive 'rbCode', ['$compile', ($compile) ->
	# helpers
	# =======
	help =
		has:
			newLines: (text) ->
				index = text.indexOf '\n'
				index isnt -1

			tabs: (text) ->
				index = text.indexOf '\t'
				index isnt -1

		get:
			firstCharIndex: (text) ->
				text.search /\S/

			firstLineTabsCnt: (text) ->
				index      = @firstCharIndex text
				whitespace = text.substring 0, index
				tabs       = whitespace.match /\t/g
				return 0 unless tabs
				tabs.length

			formattedText: (text) ->
				tabsCnt = @firstLineTabsCnt text
				re      = new RegExp "\n\t{#{tabsCnt}}", 'g'
				text    = text.trim().replace re, '\n'
				text

		compile: (text, scope, element) ->
			code = angular.element '<code></code>'
			code.text text
			$compile(code) scope.$parent
			element.append code

	# link
	# =======
	link = (scope, element, attrs, controller, transcludeFn) ->
		transcludeFn (clone) ->
			elm  = clone[0]
			return unless elm
			text = elm.textContent
			return unless text.trim()
			text = text.trimRight()
			if help.has.newLines(text) and
			   help.has.tabs text
				text = help.get.formattedText text
			help.compile text, scope, element

	# API
	# ===
	link: link
	replace: true
	transclude: true
	templateUrl: '/views/directives/code.html'
	scope:
		display: '@'
]



