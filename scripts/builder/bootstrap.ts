/* BUILDER BOOTSTRAP
 ********************/
var colors = require('colors');
colors.setTheme({
	alert:   'yellow',
	attn:    ['cyan', 'bold'],
	error:   ['red', 'bold'],
	info:    'cyan',
	minor:   'gray',
	success: ['green', 'bold']
});

interface String {
    readonly alert: string;
	readonly attn: string;
	readonly error: string;
	readonly info: string;
	readonly minor: string;
	readonly success: string;
}