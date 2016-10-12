/* Singleton
 * @class CleanDist
 * @static
 *******************/
import del = require('del')
import Task from './../Task'

class CleanDist extends Task {
	private static instance: CleanDist;

	/* Constructor
	 **************/
	private constructor() { super() }
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new CleanDist()
	}

	/* Public Methods
	 *****************/
	run(src: string[] | string = this.srcGlob) {
		var promise = del(src, this.opts);
		promise.then(() => {
			return console.log('cleaned dist'.minor)
		})
		return promise;
	}

	/* Getters and Setters
	 **********************/
	private get opts(): {} {
		return { force: true }
	}
	private get srcGlob(): string[] {
		return [ this.PATHS.dist ]
	}

}

/* Export Singleton
 *******************/
export default CleanDist.getInstance()


