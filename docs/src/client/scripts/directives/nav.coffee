angular.module('rapid-build').directive 'rbNav', ['$location', '$timeout', 'anchorService',
	($location, $timeout, anchorService) ->
		# helpers
		# =======
		getHash = (url) ->
			return if not url
			url.split('#')[1]

		getPath = (url) ->
			return if not url
			url.split('?')[0]

		getSegments = (url) ->
			return [] if not url
			path = getPath url
			segs = path.split '/'
			segs = segs.filter Boolean # removes empty strings

		isActive = (activity, needle) ->
			activity.indexOf(needle) isnt -1

		# Link
		# ====
		link = (scope, element, attrs, controllers) ->
			# responsive
			# ==========
			resHidden          = 'hidden-xs'
			scope.isResponsive = attrs.responsive isnt undefined # valueless attr
			scope.resHidden    = resHidden if scope.isResponsive

			scope.respToggle = ->
				return scope.resHidden = '' if scope.resHidden is resHidden
				scope.resHidden = resHidden

			scope.respAction = ->
				return unless scope.isResponsive
				return unless scope.respOpts
				scope.respToggle() if scope.respOpts.postAction is 'close'

			# activity helpers
			# ================
			getActivity = ->
				return unless scope.activity
				scope.activity.trim().toLowerCase()

			activityDisabled = ->
				getActivity() is 'disable'

			hasActivity = ->
				activity = getActivity()
				return false unless activity
				return true if activity is 'hash'
				return true if activity is 'path'
				return true if activity.indexOf('segment') isnt -1
				false

			setActiveHash = ->
				activeHash = $location.hash()
				for model in scope.collection
					hash = getHash model.url
					if hash is activeHash
						setActiveModel model
						break

			setActivePath = ->
				activePath = $location.path()
				for model in scope.collection
					path = getPath model.url
					if path is activePath
						setActiveModel model
						break

			setActiveSegment = ->
				segI = getActivity().replace('segment', '').trim() # segI = segment index
				segI = parseInt(segI) - 1
				return if isNaN segI
				return if segI is -1
				activeSegs = getSegments $location.path()
				for model in scope.collection
					if model.url is '/' and not activeSegs.length
						setActiveModel model
						break
					segs = getSegments model.url
					continue unless segs.length
					if segs[segI] is activeSegs[segI]
						setActiveModel model
						break

			runActivity = ->
				return if hasActiveModel()
				activity = getActivity()
				switch true
					when isActive activity, 'path' then setActivePath()
					when isActive activity, 'hash' then setActiveHash()
					when isActive activity, 'segment' then setActiveSegment()

			# active model helpers
			# ====================
			hasActiveModel = ->
				for model in scope.collection
					if model.active is true then active = true; break
				!!active

			clearActiveModel = ->
				for model in scope.collection
					if model.active is true then model.active = false; break

			setActiveModel = (model) ->
				return if model.active is 'disable'
				model.active = true

			# public methods
			# ==============
			scope.clickActive = ->
				return if hasActivity()
				return if activityDisabled()
				clearActiveModel()
				setActiveModel @model

			scope.clickAction = (model) ->
				return unless model
				return unless model.action
				model.action?(model)

			# anchor scrolling
			# ================
			scope.anchorScroll = (url) ->
				return unless getActivity() is 'hash'
				anchorService.scroll url

			# destroy (for performance)
			# =========================
			scope.$on '$destroy', ->
				lcsWatch?()
				$timeout?.cancel timeout

			# init activity
			# =============
			return unless hasActivity()
			timeout  = $timeout -> runActivity()
			lcsWatch = scope.$on '$locationChangeSuccess', (event, newUrl, oldUrl) ->
				clearActiveModel()
				runActivity()

		# API
		# ===
		link: link
		replace: true
		templateUrl: '/views/directives/nav.html'
		scope:
			activity:    '@' # disable | hash | path | segment int
			caption:     '@'
			captionIcon: '@'
			kind:        '@' # main | sub | mini
			collection:  '=' # [ active: bool | 'disable', caption: string, url: string ]
			respOpts:    '=responsive'
			separators:  '=' # currently styled for: mini
]



