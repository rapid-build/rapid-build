/* Singleton
 * @class BuildEmitter
 * @static
 **********************/
import events = require('events')
import Vinyl  = require('vinyl')

class BuildEmitter {
	private emitter = new events.EventEmitter();
	private static instance: BuildEmitter;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new BuildEmitter()
	}

	/* Public Methods
	 *****************/
	on(event: string, listener: Function) {
		this.emitter.on(event, listener);
	}

	emit(event: string, ...args: any[]) {
		return this.emitter.emit(event, args);
	}

	emitWatch(file: Vinyl) {
		var event = this.getEventName(file),
			_path = file.path;
		return this.emitter.emit(event, _path); // ex: 'change coffee'
	}

	/* Private Methods
	 ******************/
	private getTask(ext: string): string {
		return ext.slice(1);
	}

	private getEventName(file: Vinyl): string {
		var event = file['event'],
			task  = this.getTask(file.extname);
		return `${event} ${task}`;
	}

	private logMsg(event: string, _path: string, base: string) {
		var msg = 'SRC EMITTER',
			div = Array(msg.length+1).join('-');
		console.log(`${div.attn}\n${msg.attn}\n${div.attn}`)
		console.log('EVENT NAME:'.attn, event.info)
		console.log('BASE PATH:'.attn, base.info)
		console.log('FILE PATH:'.attn, _path.info)
	}

}

/* Export Singleton
 *******************/
export default BuildEmitter.getInstance()


