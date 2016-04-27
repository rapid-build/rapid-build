var path   = require('path'),
	rbRoot = process.cwd(),
	deploy = path.join(rbRoot, 'docs', 'scripts', 'deploy');

require(deploy);