/* @class Task
 * @constructor
 ***************/
import EVENTS       from './../constants/eventsConst';
import PATHS        from './../constants/pathsConst';
import Pkgs         from './../helpers/Pkgs';
import BuildEmitter from './../events/BuildEmitter';

class Task {
	protected EVENTS       = EVENTS
	protected PATHS        = PATHS
	protected eventEmitter = BuildEmitter
	protected pkgs         = Pkgs
}

/* Export It!
 *************/
export default Task


