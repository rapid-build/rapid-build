/* Singleton
 * @class SrcEmitter
 * @static
 ********************/
import events = require('events')
import Vinyl  = require('vinyl')
import Paths from './../helpers/Paths';

class SrcEmitter {
	private static instance: SrcEmitter;
	public event = new events.EventEmitter();

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new SrcEmitter()
	}

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

	private emit(file: Vinyl): boolean {
		var event = this.getEventName(file),
			_path = file.path;
		// this.logMsg(event, _path, Paths.src);
		return this.event.emit(event, _path, Paths.src); // ex: 'change coffee'
	}

	run(file: Vinyl) {
		this.emit(file);
	}
}

export default SrcEmitter.getInstance()