'use strict'

/* Log Helper
 *************/
var logBuildMsg = (build, optionsFor) => {
	var msg = 'setting ' + build + ' build options'
	console.log(optionsFor + ': ' + msg)
}

/* Common Build Options
 ***********************/
var getCommonOptions = () => {
	return {
		build: { client: false },
		browser: { open: false, reload: false },
		angular: { version: '1.2.x' }
	}
}

/* Dev Build Options
 ********************/
var setDevOptions = options => {
	options.server = {
		node_modules: ['fs-extra', 'logger']
	}
}

/* CI Build Options
 *******************/
var setCiOptions = options => {
	options.exclude = {
		from: {
			dist: {
				server: ['*', '[!pkg,*]/*']
			}
		},
		default: {
			server: {
				files: true
			}
		}
	}
}

/**
 * Get Build Options
 ********************/
var getOptions = (build, isCiBuild) => {
	logBuildMsg(build, 'common')
	var options = getCommonOptions()
	!isCiBuild ? logBuildMsg(build, 'dev') : logBuildMsg(build, 'ci')
	!isCiBuild ? setDevOptions(options) : setCiOptions(options)
	return options
}

/**
 * Export it!
 *************/
module.exports = getOptions