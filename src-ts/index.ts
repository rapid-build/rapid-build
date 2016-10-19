/* PACKAGE ENTRY SCRIPT
 ***********************/
require('./bootstrap');

module.exports = () => {
	/* es2016 array.includes
 	 ************************/
	const BUILDS1 = ['default', 'dev', 'prod']
 	var isDev = BUILDS1.includes('dev')
	console.log('es2016 array.includes:'.attn, isDev)

	/* es2017 Object.values and entries
 	 ***********************************/
 	const BUILDS2 = { default: false, dev: true,  prod: false}
 	var buildVals = Object.values(BUILDS2)
 	var buildEnts = Object.entries(BUILDS2)
	console.log('es2017 Object.values:'.attn, buildVals)
	console.log('es2017 Object.entries:'.attn, buildEnts)

	/* es2017 async functions
 	 *************************/
	var delay = time => new Promise(resolve => setTimeout(resolve, time))

	async function sleepRandom(time){
		await delay(time * 1e3);
	  	return 0 | Math.random() * 1e3;
	};

	async function sleepError(time, msg){
		await delay(time * 1e3);
		throw Error(msg);
	};

	(async () => {
		try {
			console.log('es2017 running async await:'.attn);                // => Run
			console.log(await sleepRandom(5)); // => 936, after 5 sec.
			var times = await Promise.all([
				sleepRandom(5),
				sleepRandom(15),
				sleepRandom(10)
			]);
			console.log(times);                // => 210 445 71, after 15 sec.
			await sleepError(5, 'Irror!');
			console.log('Will not be displayed');
		} catch(e) {
			console.log(e);                    // => Error: 'Irror!', after 5 sec.
		}
	})();

}