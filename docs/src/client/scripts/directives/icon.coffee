angular.module('rapid-build').directive 'rbIcon', [->
	# Link
	# ====
	link = (scope, element, attrs, controllers) ->
		kind = attrs.kind
		return unless kind

		switch true
			when kind.indexOf('fa-')  is 0 then scope.icon = 'fa '
			when kind.indexOf('ion-') is 0 then scope.icon = 'icon '
			else scope.icon = 'glyphicon glyphicon-'

		# options
		# =======
		scope.icon  += kind
		scope.size   = attrs.size # currently only large
		strong       = attrs.strong # valueless attr and accepts false
		scope.weight = 'strong' if strong isnt undefined and strong isnt 'false'

	# API
	# ===
	link: link
	replace: true
	templateUrl: '/views/directives/icon.html'
	scope: {}
]



