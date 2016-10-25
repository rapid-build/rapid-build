/* @class Base
 * @constructor
 ***************/
import paths from './../bootstrap/paths';
import env   from './../bootstrap/env'

class Base {
	readonly env = env;
	readonly paths = paths.paths;	
}

/* Export It!
 *************/
export default Base


