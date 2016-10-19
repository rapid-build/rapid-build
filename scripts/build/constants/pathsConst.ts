/* @constant PATHS
 ******************/
import path = require('path')
import Env from './../helpers/Env';
const ROOT: string = process.cwd()

const PATHS = {
	root:  ROOT,
	build: path.join(ROOT, 'scripts', 'build'),
	dist:  path.join(ROOT, 'dist'),
	src:   path.join(ROOT, Env.RB_SRC_DIR) // *src | src-ts
}

/* Export It!
 *************/
export default PATHS