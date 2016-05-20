angular.module('rapid-build').directive 'rbScroll', ['anchorService',
	(anchorService) ->
		# Link
		# ====
		link = (scope, element, attrs, controllers) ->
			helpers =
				isAnchor: ->
					tag = element[0].tagName.toLowerCase()
					tag is 'a'

				getAnchorHash: ->
					href = attrs.href or attrs.ngHref
					return unless href
					index = href.indexOf '#'
					return if index is -1
					hash = href.substr index + 1

				getAttrHash: ->
					attrs.rbScroll

				getHash: ->
					hash = @getAttrHash()
					return hash if hash
					isAnchor = @isAnchor()
					return unless isAnchor
					hash = @getAnchorHash()

			hashId = helpers.getHash()
			return unless hashId
			hasAttrHash = !!helpers.getAttrHash()

			# anchor scrolling
			# ================
			anchorScroll = ->
				opts = updateUrl: hasAttrHash, offset: 10
				anchorService.scroll hashId, opts

			# init
			# ====
			element.on 'click', anchorScroll

			# destroy
			# =======
			scope.$on '$destroy', ->
				element.off 'click', anchorScroll

		# API
		# ===
		link: link
		restrict: 'A'
]



