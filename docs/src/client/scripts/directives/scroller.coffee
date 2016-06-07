angular.module('rapid-build').directive 'rbScroller', ['$window', '$timeout', 'coordsService', 'styleService',
	($window, $timeout, coordsService, styleService) ->
		# Link
		# ====
		link = (scope, element, attrs, controllers) ->
			spy = attrs.rbScroller # currently needs to be id
			return unless spy
			spy = $window.document.getElementById spy
			return unless spy
			fixed = 'fixed'
			$win  = angular.element $window
			element.addClass 'rb-scroller'

			# elms
			# ====
			elms =
				scroll:
					elm:  element
					stop: 0 # y stop position
					hgt:  0
					wdt:  0
					yPos: 0 # set in init()
				spy:
					elm: spy
					hgt: 0
				win:
					scrollY: 0

			# timeouts
			# ========
			timeouts =
				init: null
				populateElms: null

			# helpers
			# =======
			getDimensions = (elm) ->
				dim = elm.getBoundingClientRect()
				width  = Math.floor dim.width
				height = Math.floor dim.height
				{ width, height }

			# methods
			# =======
			populateElms = (resize) ->
				timeouts.populateElms = $timeout ->
					elm = elms.scroll.elm
					elm.removeClass(fixed).css width: '' if resize and elm.hasClass fixed
					elmDim = getDimensions elm[0]
					spyDim = getDimensions elms.spy.elm
					elms.scroll.wdt  = elmDim.width  # was clientWidth
					elms.scroll.hgt  = elmDim.height
					elms.spy.hgt     = spyDim.height
					elms.scroll.stop = elms.spy.hgt - elms.scroll.hgt
				, 200

			setScrollTop = ->
				elms.win.scrollY = coordsService.windowScroll().y
				winY             = elms.win.scrollY
				elmY             = elms.scroll.yPos
				elm              = elms.scroll.elm

				if elmY >= winY
					elm.removeClass(fixed).css width: '', top: ''
				else
					stop      = elms.scroll.stop
					scrollTop = winY - elmY

					if scrollTop >= stop
						top = "#{stop}px"
						elm.removeClass(fixed).css { width: '', top }

					else if elmY <= winY
						width = "#{elms.scroll.wdt}px"
						elm.addClass(fixed).css { width, top: '' }

			# events
			# ======
			init = ->
				timeouts.init = $timeout ->
					elms.scroll.yPos = coordsService.position(element[0]).y
					setScrollTop()
				, 100

			winResize = ->
				populateElms('resize').then -> setScrollTop()

			winScroll = ->
				setScrollTop()

			# init
			# ====
			populateElms().then ->
				init().then ->
					$win.on 'scroll', winScroll
					$win.on 'resize', winResize

			# destroy (for performance)
			# =========================
			scope.$on '$destroy', ->
				$win.off 'resize', winResize
				$win.off 'scroll', winScroll
				$timeout.cancel timeouts.init
				$timeout.cancel timeouts.populateElms

		# API
		# ===
		link: link
		restrict: 'A'
]



