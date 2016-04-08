/* Requires
 ***********/
var log   = require('logger'),
	fs    = require('fs'),
	fse   = require('fs-extra'),
	path  = require('path'),
	pkg   = require(path.join(process.cwd(), 'package.json'));

/* Helpers
 **********/
var getIsWin = () => {
	return process.cwd().indexOf('\\') !== -1
}

var getIsDev = () => { // only for testing
	var src = path.join(process.cwd(), 'src');
	try { return fs.statSync(src).isDirectory() }
	catch (e) { return false }
}

var getRoot = (_isWin, _isDev) => {
	if (_isDev) return process.cwd()
	// return app/consumer's root
	var slash = _isWin ? '\\' : '/';
	return __dirname.split(`${slash}node_modules`)[0]
}

var getBuildType = () => { // only current option is --type=clarity
	var buildType = process.env.npm_config_type
	buildType = !!buildType ? buildType.trim().toLowerCase() : 'default'
	return buildType
}

/* Constants
 ************/
const
	PKG_NAME   = pkg.name,
	IS_WIN     = getIsWin(),
	IS_DEV     = getIsDev(),
	ROOT       = getRoot(IS_WIN, IS_DEV),
	BUILD_TYPE = getBuildType(),
	TPL_DIR    = path.join(__dirname, 'templates');

/* File Helper
 **************/
var buildStarter = {
	names: {
		build:     'build.js',
		options:   'build-options.js',
		gitignore: '.gitignore',
		npmignore: '.npmignore'
	},

	/* return string
	 * type = this.names[key]
	 ****************************/
	getName: function(type) {
		return this.names[type]
	},

	/* return string
	 * type = this.names[key]
	 * loc  = 'src' | 'dest'
	 * ex: file.getPath('options', 'dest')
	 *************************************/
	getPath: function(type, loc, buildType=BUILD_TYPE) {
		var name = this.getName(type);
		switch (loc) {
			case 'dest':
				if (IS_DEV) name = `-${name}`
				break
			case 'src':
				if (type.indexOf('ignore') !== -1)
					name = name.replace('.', '') + '.js'
				break
		}
		return loc === 'src' ? path.join(TPL_DIR, buildType, name) : path.join(ROOT, name)
	},

	/* return promise
	 * type = this.names[key]
	 ****************************/
	exists: function(type) {
		var dest = this.getPath(type, 'dest');
		return new Promise(
			(resolve, reject) => {
				fs.stat(dest, (e, stats) => {  // file exists?
					if (e) return reject(type) // file doesn't exist
					resolve(type)              // file exists
				})
			}
		)
	},

	/* return this
	 * type = this.names[key]
	 ****************************/
	copy: function(type, buildType=BUILD_TYPE) {
		var src  = this.getPath(type, 'src', buildType),
			dest = this.getPath(type, 'dest', buildType),
			opts = { clobber: false };

		fse.copy(src, dest, opts, e => {
			if (e && e.code == 'ENOENT' && buildType != 'default')
				return this.copy(type, 'default')
			else if (e)
				return log.error(e)
			this.logCreated(type)
		})

		return this
	},

	/* logging
	 **********/
	logCreated: function(type) {
		var name = this.getName(type);
		log.success(`${PKG_NAME} created: ${name}`)
		return this
	},

	logExists: function(type) {
		var name = this.getName(type);
		log.msg(`${PKG_NAME} file already exists: ${name}`)
		return this
	},

	logRemove: function(type) {
		var name = this.getName(type);
		log.info(`${PKG_NAME} removed ${name}`)
		return this
	},

	/* Public Methods
	 * todo: make the rest of the methods private
	 *********************************************/
	remove: function(type) {
		var dest = this.getPath(type, 'dest'),
			opts = { clobber: false };

		fse.remove(dest, e => {
			if (e) return log.error(e)
			this.logRemove(type)
		})

		return this
	},

	create: function(_type) {
		this.exists(_type).then(
			type => this.logExists(type)
		).catch(
			type => this.copy(type)
		)
		return this
	}
}

/* Export It
 ************/
module.exports = buildStarter