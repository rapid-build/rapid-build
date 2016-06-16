angular.module('rapid-build').service 'coordsService', ['$window', '$document',
	($window, $document) ->
		# methods
		# =======
		@position = (elm) ->
			# relative to document
			# http://javascript.info/tutorial/coordinates
			return unless elm
			elm     = elm[0] if elm.scope
			box     = elm.getBoundingClientRect()
			doc     = $document[0]
			body    = doc.body
			docElem = doc.documentElement

			scrollTop  = $window.pageYOffset or docElem.scrollTop  or body.scrollTop
			scrollLeft = $window.pageXOffset or docElem.scrollLeft or body.scrollLeft
			clientTop  = docElem.clientTop   or body.clientTop     or 0
			clientLeft = docElem.clientLeft  or body.clientLeft    or 0

			y = box.top  + scrollTop  - clientTop
			x = box.left + scrollLeft - clientLeft
			y = Math.round y
			x = Math.round x

			coords = { x, y }

		@windowScroll = ->
			xScroll = $window.scrollX or $window.pageXOffset
			yScroll = $window.scrollY or $window.pageYOffset

			coords = x: xScroll, y: yScroll


		@

]