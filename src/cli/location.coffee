# Output the location where build is installed.
# =============================================
module.exports = (config) ->
	return unless config.build.cli.opts.location

	# return
	# ======
	location = config.build.path # :string
	console.log location.attn
	location
