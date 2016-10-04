/* Singleton
 * @class BuildEmitter
 * @static
 **********************/
import events = require('events');

class BuildEmitter {
	private static instance: BuildEmitter;
	public event = new events.EventEmitter();

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new BuildEmitter()
	}
}

export default BuildEmitter.getInstance()