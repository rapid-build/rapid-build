/* Singleton
 * @class SrcEmitter
 * @static
 ********************/
import events = require('events');

class SrcEmitter {
	private static instance: SrcEmitter;
	private event = new events.EventEmitter();

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new SrcEmitter()
	}

	run(file) {
		// this.event.emit('')
		console.log(file.extname)
	}
}

export default SrcEmitter.getInstance()