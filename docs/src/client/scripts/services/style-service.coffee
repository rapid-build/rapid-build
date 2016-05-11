angular.module('rapid-build').service 'styleService', ['$window',
	($window) ->
		# methods
		# =======
		@get = (elm, prop) ->
			return unless elm
			return unless prop
			elm = elm[0] if elm.scope
			$window.getComputedStyle(elm).getPropertyValue prop

		@set = (elm, prop, val) ->
			return unless elm
			return unless prop
			return unless val
			elm = elm[0] if elm.scope
			elm.style[prop] = val

		@

]