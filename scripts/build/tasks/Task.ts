/* @class Task
 * @constructor
 ***************/
import path = require('path')
import * as fse from 'fs-extra-promise'
const ROOT: string = process.cwd()

class Task {
	protected fse = fse;
	protected paths = {
		root: ROOT,
		dist: path.join(ROOT, 'dist')
	}
	protected constructor() {}
}

export default Task