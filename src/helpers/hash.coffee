getHash = require 'sha1'

module.exports =
	create: (str, opts={}) ->
		return '' unless str
		hash = getHash str
		return hash if isNaN opts.length
		hash.substring 0, opts.length

	getPathHash: (_path, opts={}) ->
		return '' unless _path
		opts.length = opts.length or 3
		hash = @create _path, opts
		"-#{hash}"
