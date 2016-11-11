/* GULP-VINYL (PLUGIN)
 * Turn stream file into full vinyl file.
 ****************************************/
const PLUGIN_NAME = 'gulp-vinyl';
import Vinyl   = require('vinyl')
import through = require('through2')

/* The Plugin
 *************/
var gulpVinyl = (opts = {}) => {
	return through.obj((file, enc, cb) => {
		var vFile = new Vinyl({
			cwd:      file.cwd,
			base:     file.base,
			path:     file.path,
			history:  file.history,
			stat:     file.stat,
			contents: file.contents
		});

		cb(null, vFile);
	})
}

/* Export It!
 *************/
export default gulpVinyl;
