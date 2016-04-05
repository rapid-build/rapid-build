# Build Options
# =============
logBuildMsg = (build, optionsFor) ->
	msg = 'setting ' + build + ' build options'
	console.log optionsFor + ': ' + msg
	return

# Common Build Options
# ====================
getCommonOptions = ->
	minify: spa: file: false
	spa: src: filePath: 'spa.html'
	angular:
		moduleName: 'rapid-build'
		templateCache:
			dev: true
			useAbsolutePaths: true
	exclude:
		from:
			dist:
				client: [
					'bower_components/jquery/dist/jquery.js',
					'bower_components/bootstrap/less/bootstrap.less'
					'bower_components/bootstrap/dist/js/bootstrap.js'
				]
	order:
		scripts:
			first: [
				'scripts/prototypes/*.*'
			]
	extra:
		copy:
			client: [
				'bower_components/bootstrap/fonts/**'
			]
		compile:
			client:
				less: ['bower_components/bootstrap/less/bootstrap.less']

# Dev Build Options
# =================
setDevOptions = (options) ->
	return

# CI Build Options
# =================
setCiOptions = (options) ->
	return

# Get Build Options
# =================
getOptions = (build, isCiBuild) ->
	logBuildMsg build, 'common'
	options = getCommonOptions()
	if !isCiBuild then logBuildMsg(build, 'dev') else logBuildMsg(build, 'ci')
	if !isCiBuild then setDevOptions(options) else setCiOptions(options)
	options

# Export it!
# ==========
module.exports = getOptions



