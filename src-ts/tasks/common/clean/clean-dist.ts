/* @class Singleton
 *******************/
import del = require('del')
import Base  from './../../../common/Base'
import ITask from './../../../interfaces/ITask'

class Singleton extends Base implements ITask {
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
			console.log('cleaned dist'.minor)
			return true
		})
		return promise;
	}

	/* Getters and Setters
	 **********************/
	private get opts(): {} {
		return { force: true }
	}
	private get srcGlob(): string[] {
		return [ this.paths.app.dist.path ]
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


