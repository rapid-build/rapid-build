/* @constant EVENTS
 *******************/
const EVENTS = {
	change: {
		coffee: {
			msg: 'coffee change:',
			event: 'change coffee'
		},
		ts: {
			msg: 'typescript change:',
			event: 'change typescript'
		},
		other: {
			msg: 'src change:',
			event: 'change src'
		}
	},
	restart: {
		build: {
			msg: 'build restart:',
			event: 'restart build'
		}
	}
}

/* Export It!
 *************/
export default EVENTS