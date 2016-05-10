# Build Options
# =============
logBuildMsg = (build, optionsFor) ->
	msg = 'setting ' + build + ' build options'
	console.log optionsFor + ': ' + msg
	return

# Common Build Options
# ====================
getCommonOptions = ->
	# browser: open: false
	spa:
		src:
			filePath: 'spa.html'
	minify:
		spa:
			file: false
		css:
			splitMinFile: false
		html:
			options:
				ignoreCustomFragments: [
					/<rb:code(\s*?.*?)*?rb:code>/gi
					/<rb:pre(\s*?.*?)*?rb:pre>/gi
					/\s?<rb:icon\s|<\/rb:icon>\s?/gi
				]
	angular:
		moduleName: 'rapid-build'
		modules: ['angular-bind-html-compile', 'hljs']
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
					'libs/bootstrap/bootstrap.less'
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
				'bower_components/font-awesome/fonts/**'
				'bower_components/bootstrap/dist/fonts/**'
			]
		compile:
			client:
				less: [
					'libs/bootstrap/bootstrap.less'
				]
		minify:
			client:
				css: [
					'libs/bootstrap/bootstrap.css'
				]

# Dev Build Options
# =================
setDevOptions = (options, build) ->
	return setProdOptions options, build if build.indexOf('prod') isnt -1
	logBuildMsg build, 'DEV'
	options.extra.copy.client.push(
		'bower_components/font-awesome/css/font-awesome.css'
	)

# Prod Build Options
# ==================
setProdOptions = (options, build) ->
	logBuildMsg build, 'PROD'
	options.extra.copy.client.push(
		'bower_components/font-awesome/css/font-awesome.min.css'
	)

# CI Build Options
# =================
setCiOptions = (options, build) ->
	logBuildMsg build, 'CI'

# Get Build Options
# =================
getOptions = (build, isCiBuild) ->
	logBuildMsg build, 'common'
	options = getCommonOptions()
	if !isCiBuild then setDevOptions options, build else setCiOptions options, build
	options

# Export it!
# ==========
module.exports = getOptions



