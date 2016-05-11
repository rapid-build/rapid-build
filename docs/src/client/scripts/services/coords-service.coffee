angular.module('rapid-build').service 'coordsService', ['$window', '$document',
	($window, $document) ->
		# methods
		# =======
		@position = (elm) ->
			return unless elm
			elm = elm[0] if elm.scope
			doc = $document[0]
			xPos = 0
			yPos = 0
			while elm
				if elm.tagName and elm.tagName.toLowerCase() is 'BODY'
					# deal with browser quirks with body/window/document and page scroll
					xScroll = elm.scrollLeft or doc.documentElement.scrollLeft
					yScroll = elm.scrollTop  or doc.documentElement.scrollTop
					xPos   += elm.offsetLeft - xScroll + elm.clientLeft
					yPos   += elm.offsetTop  - yScroll + elm.clientTop
				else
					# for all other non-BODY elements
					xPos += elm.offsetLeft - elm.scrollLeft + elm.clientLeft
					yPos += elm.offsetTop  - elm.scrollTop  + elm.clientTop
				elm = elm.offsetParent

			coords = x: xPos, y: yPos

		@windowScroll = ->
			xScroll = $window.scrollX or $window.pageXOffset
			yScroll = $window.scrollY or $window.pageYOffset

			coords = x: xScroll, y: yScroll


		@

]