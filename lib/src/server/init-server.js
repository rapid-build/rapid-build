var appFilePath, bodyParser, clientDirPath, config, dir, e, error, express, path, proxyFilePath, server, serverDirPath;

dir = __dirname;

path = require('path');

express = require('express');

bodyParser = require('body-parser');

config = require(path.join(dir, 'config.json'));

appFilePath = path.resolve(dir, '..', config.dist.app.server.scripts.file);

clientDirPath = path.resolve(dir, '..', '..', config.dist.app.client.dirName);

serverDirPath = path.resolve(dir, '..', '..', config.dist.app.server.dirName);

server = require('./server');

server.express = express;

server.app = server.express();

server.middleware = {
  bodyParser: bodyParser
};

server.paths = {
  client: clientDirPath,
  server: serverDirPath
};

server.server = require('./start-server')(server.app, config);

require('./defaults/app-settings')(server, config);

require('./defaults/app-middleware')(server, config);

proxyFilePath = path.join(dir, 'options', 'http-proxy.js');

if (config.httpProxy.length) {
  require(proxyFilePath)(server.app, config);
}

try {
  require(appFilePath)(server);
} catch (error) {
  e = error;
  if (e.code && e.code.toLowerCase() === 'module_not_found' && e.message.indexOf(appFilePath) !== -1) {
    console.log('No application server scripts to load.');
  } else {
    console.log(e);
  }
}

require('./defaults/app-routes')(server, config);
