/* Singleton
 * @class CleanDist
 * @static
 *******************/
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
	run() {
		var promise = this.pkgs.fse.removeAsync(this.paths.dist);
		promise.then(() => {
			return console.log('cleaned dist'.info)
		})
		return promise;
	}

}

/* Export Singleton
 *******************/
export default CleanDist.getInstance()


