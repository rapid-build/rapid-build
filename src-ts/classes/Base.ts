/* @class Base
 * @constructor
 ***************/
import paths from './../bootstrap/paths';
import env   from './../bootstrap/env'

class Base {
	protected env   = env
	protected paths = paths.get()
}

/* Export It!
 *************/
export default Base


