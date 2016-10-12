/* @constant EVENTS
 *******************/
const EVENTS = {
	change: {
		coffee: 'change coffee',
		ts:     'change typescript',
		src:    'change src'
	},
	add: {
		coffee: 'add coffee',
		ts:     'add typescript',
		src:    'add src'
	},
	unlink: {
		coffee: 'delete coffee',
		ts:     'delete typescript',
		src:    'delete src'
	},
	restart: {
		build:  'restart build'
	}
}

/* Export It!
 *************/
export default EVENTS