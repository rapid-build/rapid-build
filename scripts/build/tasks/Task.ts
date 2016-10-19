/* @class Task
 * @constructor
 ***************/
import EVENTS       from './../constants/eventsConst';
import PATHS        from './../constants/pathsConst';
import Env          from './../helpers/Env';
import BuildEmitter from './../events/BuildEmitter';
import CleanDist    from './tasks/CleanDist';
import Path         from './../helpers/Path';

class Task {
	protected EVENTS       = EVENTS
	protected PATHS        = PATHS
	protected Env          = Env
	protected eventEmitter = BuildEmitter
	protected tasks = {
		CleanDist
	}
	protected utils = {
		Path
	}
}

/* Export It!
 *************/
export default Task


