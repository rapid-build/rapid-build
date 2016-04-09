# Build Options
# =============
logBuildMsg = (build, optionsFor) ->
	msg = 'setting ' + build + ' build options'
	console.log optionsFor + ': ' + msg
	return

# Common Build Options
# ====================
getCommonOptions = ->
	minify:
		spa:
			file: false
	spa:
		src:
			filePath: 'spa.html'
	angular:
		moduleName: 'rapid-build'
		modules: ['hljs']
		templateCache:
			dev: true
			useAbsolutePaths: true
	order:
		scripts:
			first: [
				'scripts/prototypes/*.*'
				'libs/highlight/highlight.pack.js'
			]
	exclude:
		from:
			dist:
				client: [
					'bower_components/jquery/**'
					'bower_components/font-awesome/less/**'
					'bower_components/font-awesome/scss/**'
					'bower_components/bootstrap/less/**'
					'bower_components/bootstrap/dist/js/**'
				]
	extra:
		copy:
			client: [
				'bower_components/Ionicons/fonts/**'
				'bower_components/bootstrap/dist/fonts/**'
				'bower_components/bootstrap/dist/css/bootstrap.css'
				'bower_components/font-awesome/fonts/**'
				'bower_components/font-awesome/css/font-awesome.css'
			]

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



