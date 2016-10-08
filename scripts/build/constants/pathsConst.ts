/* @constant PATHS
 ******************/
import path = require('path')
const ROOT: string = process.cwd()

const PATHS = {
	root:  ROOT,
	build: path.join(ROOT, 'scripts', 'build'),
	dist:  path.join(ROOT, 'dist'),
	src:   path.join(ROOT, 'src')
}

/* Export It!
 *************/
export default PATHS