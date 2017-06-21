/* SCRIPTS LIB CONTROLLER
 *************************/
require('../bootstrap');
var env = require('../utils/env');
var log = require('../utils/log');

// Is Consumer or Local Install?
env.isConsumer(true).then(isConsumer => {
	var task = isConsumer ?
		{ msg: 'unpack server', path: './unpack-lib-server' } :
		{ msg: 'create lib', path: './create-lib' };

	// Log Task
	log.msgWithSeps(task.msg, 'info', true, true, true)
	log.msg(`is consumer install: ${isConsumer}`);

	// Run Task
	require(task.path)().then(res => {
		log.msgWithSeps(`${res.msg}\n`, 'attn', true, false);
	})
	.catch(e => {
		log.msgWithSeps(`failed to ${task.msg}`, 'error', true, true, true);
		log.msg(`Error: ${e.message}\n`, 'error');
	});
})
.catch(e => {
	log.msg(`Error: ${e.message}\n`, 'error');
});