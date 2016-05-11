angular.module('rapid-build').service 'anchorService', ['$document',
	($document) ->
		# methods
		# =======
		@scroll = (url) ->
			return unless url
			index = url.indexOf '#'
			return if index is -1
			id  = url.substr index + 1
			elm = $document[0].getElementById id
			return unless elm
			$document.scrollToElementAnimated elm

		@

]