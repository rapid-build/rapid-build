angular.module('rapid-build').service 'preService', [->
	# methods
	# =======
	@has =
		newLines: (text) ->
			index = text.indexOf '\n'
			index isnt -1

		tabs: (text) ->
			index = text.indexOf '\t'
			index isnt -1

	@get =
		firstCharIndex: (text) ->
			text.search /\S/

		firstLineTabsCnt: (text) ->
			index      = @firstCharIndex text
			whitespace = text.substring 0, index
			tabs       = whitespace.match /\t/g
			return 0 unless tabs
			tabs.length

		formattedText: (text) ->
			tabsCnt = @firstLineTabsCnt text
			re      = new RegExp "\n\t{#{tabsCnt}}", 'g'
			text    = text.trim().replace re, '\n'
			text

		text: (text) =>
			text = text.trimRight()
			return text unless @has.newLines(text) and @has.tabs text
			text = @get.formattedText text


	@

]