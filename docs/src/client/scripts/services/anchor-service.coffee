angular.module('rapid-build').service 'anchorService', ['$window', '$document',
	($window, $document) ->
		# methods
		# =======
		@_getId = (url) ->
			return unless url
			index = url.indexOf '#'
			return if index is -1
			id  = url.substr index + 1

		@scroll = (id, opts={}) ->
			id = @_getId id if opts.getId
			return unless id
			elm = $document[0].getElementById id
			return unless elm
			opts.offset = 8 if opts.offset is undefined
			$document.scrollToElementAnimated elm, opts.offset
			return unless opts.updateUrl
			$window.location.hash = id

		@

]