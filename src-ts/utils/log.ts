/* LOG UTILITY
 **************/
class Singleton {
	private static instance: Singleton;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}

	/* Public Methods
	 *****************/
	msg(msg: string, type='info', uppercase=false): this {
		msg = uppercase ? msg.toUpperCase() : msg;
		console.log(msg[type])
		return this
	}

	msgDivs(msg: string, type='info', top=true, bot=true, uppercase=false): this {
		var div = Array(msg.length+1).join('-'),
			tDiv = top ? `${div}\n` : '',
			bDiv = bot ? `\n${div}` : '';
		msg = uppercase ? msg.toUpperCase() : msg;
		msg = `${tDiv}${msg}${bDiv}`;
		console.log(msg[type])
		return this
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()