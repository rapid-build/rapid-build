angular.module('rapid-build').directive 'rbNav', ['$location', '$timeout',
	($location, $timeout) ->
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
			# defaults: valueless attrs
			scope.responsive = attrs.responsive isnt undefined

			# responsive
			# ==========
			resHidden = 'hidden-xs'
			scope.resHidden = resHidden if scope.responsive
			scope.toggle = ->
				return scope.resHidden = '' if scope.resHidden is resHidden
				scope.resHidden = resHidden

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
			separators:  '=' # currently styled for: mini
			# ---------------
			# valueless attrs
			# ---------------
			# responsive: '@' # currently styled for: main | sub
]



