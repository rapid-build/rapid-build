/* Singleton
 * @class CleanLib
 * @static
 ******************/
import Task from './../Task'

class CleanLib extends Task {
	private static instance: CleanLib;

	/* Constructor
	 **************/
	private constructor() { super() }
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new CleanLib()
	}

	/* Public Methods
	 *****************/
	run() {
		return this.pkgs.fse.removeAsync(this.paths.dist)
		.then(() => {
			return console.log('dist cleaned'.info)
		})
	}

}

/* Export Singleton
 *******************/
export default CleanLib.getInstance()


