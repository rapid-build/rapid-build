/* @class Singleton
 *******************/
import path   = require('path')
import events = require('events')
import Vinyl  = require('vinyl')
import EVENTS from './../constants/eventsConst';
import PATHS  from './../constants/pathsConst';

class Singleton {
	private emitter = new events.EventEmitter();
	private static instance: Singleton;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
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
		var event  = this.getEvent(file);
		var result = this.emitter.emit(event, file);
		this.logWatchMsg(file, event);
		return result;
	}

	/* Private Methods
	 ******************/
	private getEvent(file: Vinyl): string {
		if (this.isBuildChange(file)) return EVENTS.restart.build;

		var event = file['event'];
		var ext   = this.getFileExt(file);

		if (!this.isEventType(file)) return EVENTS[event].src

		return EVENTS[event][ext]; // ex: 'change coffee'
	}

	private logWatchMsg(file: Vinyl, event: string): void {
		if (this.isBuildChange(file)) return; // log happens in Build.ts

		var msgs = event.split(' ');
		var msg = `${msgs[1]} ${msgs[0]}: ${path.sep}${file.relative}`;
		var div = Array(new Array(30).length).join('-');

		console.log(`${div}\n${msg}`.minor)
	}

	private isBuildChange(file: Vinyl): boolean {
		var isBuildChange = file.path.indexOf(PATHS.build) !== -1;
		return isBuildChange;
	}

	private getFileExt(file: Vinyl): string {
		return file.extname.slice(1);
	}

	private isEventType(file: Vinyl): boolean {
		var ext = this.getFileExt(file);
		return !!EVENTS[file['event']][ext]
	}

}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


