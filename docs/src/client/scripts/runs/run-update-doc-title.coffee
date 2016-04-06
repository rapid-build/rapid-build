angular.module('rapid-build').run ['$rootScope',
	($rootScope) ->
		doc         = window.document
		separator   = '·'
		DOC_TITLE   = "#{doc.title} #{separator} Develop Rapidly!"
		sepIndex    = DOC_TITLE.indexOf(separator) + 2
		commonTitle = DOC_TITLE.slice 0, sepIndex

		# helpers
		# =======
		setTitle = (title, prependCommon = true, toTitleCase = true) ->
			title = title.toTitleCase() if toTitleCase
			title = commonTitle + title if prependCommon
			doc.title = title

		# route change success
		# ====================
		$rootScope.$on '$routeChangeSuccess', (e, current, previous) ->
			return unless current.$$route # for router otherwise
			return if current.redirectTo  # fix for double calls to same route

			# home page
			isHomePage = current.$$route.originalPath is '/'
			return setTitle DOC_TITLE, false, false if isHomePage

			# route title
			title = current.$$route.title
			return setTitle title if title

			# dynamic title, last segement of path
			path  = current.$$route.originalPath
			index = path.lastIndexOf('/') + 1
			title = path.slice(index).replace /-/g, ' '
			setTitle title
]