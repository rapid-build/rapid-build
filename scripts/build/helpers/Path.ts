/* @class Path Utilities
 ************************/
import nPath = require('path')
import PATHS from './../constants/pathsConst';

class Path {
	private _path: string;

	/* Constructor
	 * @param {string} path - absolute file path
	 ********************************************/
	constructor(path: string) {
		this.path = path;
	}

	/* Public Methods
	 *****************/
	srcToDist(): this {
		this.path = this.path.replace(PATHS.src, PATHS.dist);
		return this;
	}

	swapExt(ext: string): this {
		var nExt = nPath.extname(this.path);
		if (!nExt) return this;
		if (ext[0] !== '.') ext = `.${ext}`;
		this.path = this.path.replace(nExt, ext);
		return this;
	}

	/* Getters and Setters
	 **********************/
	get path(): string {
		return this._path
	}
	set path(val: string) {
		this._path = val
	}

}

/* Export It!
 *************/
export default Path;


