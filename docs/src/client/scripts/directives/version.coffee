angular.module('rapid-build').directive 'rbVersion', ['RB_VERSION', (RB_VERSION) ->
		# Link
		# ====
		link = (scope, element, attrs, controllers) ->
			version = RB_VERSION
			version = "v#{version}" if attrs.tag isnt undefined and attrs.msg is undefined
			version = "Latest Version: v#{version}" if attrs.msg isnt undefined
			scope.version = version

		# API
		# ===
		link: link
		replace: true
		templateUrl: '/views/directives/version.html'
		scope: {}
]



