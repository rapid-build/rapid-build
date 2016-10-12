/* @class Singleton
 *******************/
import del = require('del')
import Task from './../Task'

class Singleton extends Task {
	private static instance: Singleton;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}

	/* Public Methods
	 *****************/
	run(src: string[] | string = this.srcGlob) {
		var promise = del(src, this.opts).then((paths) => {
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
export default Singleton.getInstance()


