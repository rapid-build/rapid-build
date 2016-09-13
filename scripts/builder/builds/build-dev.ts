/* DEV BUILDER
 **************/
import path = require('path')
import * as fse         from 'fs-extra'
import * as bluebird    from 'bluebird'
import { async, await } from 'asyncawait'

// create fse promises
var fsa = {
	removeAsync: bluebird.promisify(fse.remove)
}

var buildDev = (rbRoot: string) => {
	var dist = path.join(rbRoot, 'dist');

	var tasks = {
		cleanLib: () => {
			return fsa.removeAsync(dist).then(() => {
				console.log('dist cleaned')
			})
		}
	}

	var runTasks = async(() => {
		await(tasks.cleanLib());
	});

	return runTasks()
}

export default buildDev