/* Common Paths
 * Singleton
 * @class Paths
 * @static
 **************/
import path = require('path')
const ROOT: string = process.cwd()

class Paths {
	readonly paths = {
		root:  ROOT,
		build: path.join(ROOT, 'scripts', 'build'),
		dist:  path.join(ROOT, 'dist'),
		src:   path.join(ROOT, 'src')
	}
	private static instance: Paths;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Paths()
	}

}

/* Export Singleton
 *******************/
export default Paths.getInstance().paths


