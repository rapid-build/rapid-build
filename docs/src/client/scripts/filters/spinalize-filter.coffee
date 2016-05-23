angular.module('rapid-build').filter 'spinalize', ->
	(input) ->
		return unless input
		input.replace /\s/g, '-'