angular.module('rapid-build').directive 'rbSort', [ ->
	# private
	# =======
	Groups = {} # see scope.group

	# Helpers
	# =======
	help =
		init:
			add:
				group: (group, scope) ->
					return unless group
					Groups[group] = [] unless Array.isArray Groups[group]
					Groups[group].push scope

			get:
				active: (active, attrs) ->
					return active if typeof active isnt 'undefined'
					return true if typeof attrs.active isnt 'undefined'
					false

				order: (order, attrs, active) ->
					return order  if order
					return 'asc'  if typeof attrs.asc  isnt 'undefined'
					return 'desc' if typeof attrs.desc isnt 'undefined'
					return 'asc'
		is:
			group: (group) ->
				return false unless group
				return false unless Groups[group]
				true

		action:
			clear:
				actives: (group, active) ->
					return true if active
					return unless help.is.group group
					scope.active = false for scope in Groups[group]

			destroy:
				group: (group) ->
					return unless help.is.group group
					delete Groups[group]

			get:
				active: (active) ->
					return true if active
					active = !active

				order: (order) ->
					return 'desc' if order is 'asc'
					'asc'

	# Link
	# ====
	link = (scope, element, attrs, controllers) ->
		init = ->
			help.init.add.group scope.group, scope
			scope.active = help.init.get.active scope.active, attrs
			scope.order  = help.init.get.order scope.order, attrs, scope.active
			if scope.active and typeof attrs.init is 'undefined'
				scope.order = help.action.get.order scope.order
			return if typeof attrs.init is 'undefined'
			scope.action()

		# methods
		# =======
		scope.action = ->
			order = scope.order
			sort  = scope.sort
			opts  = { order, sort }
			scope.onAction { opts }
			scope.order = help.action.get.order scope.order
			help.action.clear.actives scope.group, scope.active
			scope.active = help.action.get.active scope.active

		# destroy
		# =======
		scope.$on '$destroy', ->
			help.action.destroy.group scope.group

		# init
		# ====
		init()

	# API
	# ===
	link: link
	replace: true
	templateUrl: '/views/directives/sort.html'
	# valueless attrs: active | asc | desc | init
	scope:
		onAction: '&action'
		caption:  '@'
		group:    '@'
		kind:     '@'
		active:   '=?'
		order:    '=?'
		sort:     '@'
]



