/* Singleton
 * @class Builder
 * @static
 *****************/
import './bootstrap';
import DevBuild from './builds/DevBuild';

class Builder {
	private static instance: Builder;

	private constructor() {}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Builder()
	}

	build() {
		return DevBuild.run()
	}
}

var instance = Builder.getInstance()
export { instance }