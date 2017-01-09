/* SCRIPTS LIB CONTROLLER
 *************************/
require('../bootstrap');
var rbRoot = process.cwd(),
	log    = require('../utils/log'),
	task   = {};
task.name  = process.argv[2];
task.path  = `./${task.name}`;
task.msg   = task.name.replace(/-/g,' ');

/* Log Task
 ***********/
log.msgWithSeps(task.msg, 'info', true, true, true)

/* Run Task
 ***********/
require(task.path)(rbRoot).then(res => {
	log.msgWithSeps(`${task.msg} (complete)`, 'attn', true, false);
	console.log(); // formatting, log extra line
})
.catch(e => {
	log.msgWithSeps(`failed to ${task.msg}`, 'error', true, true, true);
	log.msg(`Error: ${e.message}\n`, 'error');
})