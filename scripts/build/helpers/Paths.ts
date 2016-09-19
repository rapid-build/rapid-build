/* Common Paths
 * Singleton
 * @class Paths
 * @static
 **************/
import path = require('path')
const ROOT: string = process.cwd()

class Paths {
	private static instance: Paths;
	protected constructor() {}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Paths()
	}

	readonly paths = {
		root:  ROOT,
		build: path.join(ROOT, 'scripts', 'build'),
		dist:  path.join(ROOT, 'dist'),
		src:   path.join(ROOT, 'src')
	}

}

export default Paths.getInstance().paths