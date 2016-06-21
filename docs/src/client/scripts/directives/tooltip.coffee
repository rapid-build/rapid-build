angular.module('rapid-build').directive 'rbTooltip',
	['$compile', '$document', '$parse', '$templateCache', '$timeout', 'coordsService', 'uidService',
	($compile, $document, $parse, $templateCache, $timeout, coordsService, uidService) ->
		# globals
		# =======
		global =
			tips: []
			template: $templateCache.get '/views/directives/tooltip.html'

		# link
		# ====
		link = (scope, $elm, attrs, controllers) ->
			title = attrs.title
			return unless title
			id      = null
			timeout = null
			$tip    = null
			$body   = $document.find 'body'

			# api options
			# delay:    1500
			# action:   hover | click | mouseout
			# position: top | bottom | left | right
			# =====================================
			api = $parse(attrs.rbTooltip)() or {}
			api.delay    = api.delay    or 1500 # for click action
			api.actions  = api.action   or 'hover'
			api.position = api.position or 'top'

			# api helpers
			# ===========
			apiHelp =
				init: ->
					@formatActions()
					@events 'on'
					@

				formatActions: -> # turn into array
					actions    = api.actions.split ' '
					opts       = ['click', 'hover', 'mouseout']
					apiActions = []
					for action, i in actions
						action = action.toLowerCase()
						continue unless action
						continue if opts.indexOf(action) is -1
						if action is 'hover'
							apiActions.push 'mouseover', 'mouseout'
						else
							apiActions.push action
					api.actions = apiActions

				events: (toggle) -> # on or off
					for action in api.actions
						$elm[toggle] action, events[action]

			# helpers
			# =======
			help =
				init: ->
					$elm.attr 'title', ''
					$tip = $compile(global.template) scope
					$tip.addClass api.position
					tip = $tip[0].querySelector '[data-tooltip]'
					tip.innerHTML = title
					$tip = $compile($tip) scope # incase directives
					@

				destroyTip: ->
					$tip.remove()
					return @ unless global.tips.length
					index = null
					for tip, i in global.tips
						if tip.id is id then index = i; break
					return @ if index is null
					global.tips.splice index, 1
					@

				appendToBody: ->
					$body.append $tip unless id
					@

				setId: ->
					return @ if !!id
					id = uidService.next()
					@addToTips()

				addToTips: ->
					global.tips.push { id, $tip }
					@

				hideTip: ->
					$tip.removeClass 'in'
					@

				hideTipDelay: ->
					$timeout.cancel timeout
					timeout = $timeout ->
						help.hideTip()
					, api.delay
					@

				hideTips: ->
					return @ unless global.tips.length
					for tip in global.tips
						continue if tip.id is id
						tip.$tip.removeClass 'in'
					@

				showTip: ->
					help.hideTips().appendToBody().setId()
					css = help.get.position[api.position]()
					$tip.css(css).addClass 'in'
					@

				get:
					position:
						topOrBottom: (position='top') ->
							elmCrds = coordsService.position $elm[0]
							elmDim  = $elm[0].getBoundingClientRect()
							tipDim  = $tip[0].getBoundingClientRect()
							top     = elmCrds.y - tipDim.height if position is 'top'
							top     = elmCrds.y + elmDim.height if position is 'bottom'
							left    = (elmCrds.x + (elmDim.width / 2)) - (tipDim.width / 2)
							pos     = top: "#{top}px", left: "#{left}px"

						leftOrRight: (position='left') ->
							elmCrds = coordsService.position $elm[0]
							elmDim  = $elm[0].getBoundingClientRect()
							tipDim  = $tip[0].getBoundingClientRect()
							top     = (elmCrds.y + (elmDim.height / 2)) - (tipDim.height / 2)
							left    = elmCrds.x - tipDim.width if position is 'left'
							left    = elmCrds.x + elmDim.width if position is 'right'
							pos     = top: "#{top}px", left: "#{left}px"

						top: ->
							@topOrBottom 'top'

						bottom: ->
							@topOrBottom 'bottom'

						left: ->
							@leftOrRight 'left'

						right: ->
							@leftOrRight 'right'

			# events
			# ======
			events =
				click: ->
					help.showTip().hideTipDelay()

				mouseover: ->
					help.showTip()

				mouseout: ->
					help.hideTip()

			# init
			# ====
			apiHelp.init()
			help.init()

			# destroy (for performance)
			# =========================
			scope.$on '$destroy', ->
				help.destroyTip()
				$timeout.cancel timeout
				apiHelp.events 'off'

		# API
		# ===
		link: link
		restrict: 'A'
]



