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
	// return build options
	// find available options here: http://aim-npm-server/
	return {}
}

/* Dev Build Options
 ********************/
var setDevOptions = options => {
	// add to or modify options here, example below:
	// options.build = { client: false }
}

/* CI Build Options
 *******************/
var setCiOptions = options => {
	// add to or modify options here, example below:
	// options.build = { client: false }
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