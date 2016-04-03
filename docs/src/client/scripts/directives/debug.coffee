angular.module('rapid-build').directive 'rbDebug', [->
	# API
	# ===
	replace: true
	templateUrl: '/views/directives/debug.html'
	scope:
		caption: '@'
		kind:    '@'
		model:   '='
]



