/* BUILDER SINGLETON
 ********************/
import './bootstrap';
import buildDev from './builds/build-dev';

class Builder {
	private root: string;
	private static instance: Builder;

	private constructor() {
		this.root = process.cwd()
	}

	static getInstance() {
		if (!Builder.instance) {
			Builder.instance = new Builder()
		}
		return Builder.instance
	}

	build() { // returns promise
		return buildDev(this.root)
	}
}

var instance = Builder.getInstance()
export { instance }