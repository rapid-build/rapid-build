/* @class Task
 * @constructor
 ***************/
import Pkgs         from './../helpers/Pkgs';
import Paths        from './../helpers/Paths';
import BuildEmitter from './../events/BuildEmitter';

class Task {
	protected eventEmitter = BuildEmitter
	protected pkgs         = Pkgs
	protected paths        = Paths
}

/* Export It!
 *************/
export default Task


