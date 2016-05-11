angular.module('rapid-build').directive 'rbScroller', ['$window', '$timeout', 'coordsService', 'styleService',
	($window, $timeout, coordsService, styleService) ->
		# Link
		# ====
		link = (scope, element, attrs, controllers) ->
			spy = attrs.rbScroller # currently needs to be id
			return unless spy
			spy = $window.document.getElementById spy
			return unless spy
			$win = angular.element $window
			element.addClass 'rb-scroller'

			# elms
			# ====
			elms =
				scroll:
					elm:  element
					stop: 0 # y stop position
					hgt:  0
					top:  0
					yPos: coordsService.position(element).y
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

			# methods
			# =======
			populateElms = ->
				timeouts.populateElms = $timeout ->
					elms.scroll.hgt  = elms.scroll.elm[0].clientHeight
					elms.spy.hgt     = elms.spy.elm.clientHeight
					elms.scroll.stop = elms.spy.hgt - elms.scroll.hgt
				, 100

			setScrollTop = ->
				elms.win.scrollY = coordsService.windowScroll().y

				if elms.win.scrollY <= elms.scroll.yPos
					return elms.scroll.elm.css top: "#{elms.scroll.top}px"

				scrollTop = elms.win.scrollY - elms.scroll.yPos

				return if elms.scroll.stop <= scrollTop
				elms.scroll.elm.css top: "#{scrollTop}px"

			# events
			# ======
			init = ->
				timeouts.init = $timeout ->
					elms.scroll.top = styleService.get elms.scroll.elm, 'top'
					elms.scroll.top = elms.scroll.top.replace 'px', ''
					elms.scroll.top = parseInt elms.scroll.top
				, 100

			winResize = ->
				populateElms().then -> setScrollTop()

			winScroll = ->
				setScrollTop()

			# init
			# ====
			init().then ->
				populateElms().then ->
					setScrollTop()
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



