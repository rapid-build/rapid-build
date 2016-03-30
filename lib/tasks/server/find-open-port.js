module.exports = function(config, gulp, taskOpts) {
  var api, buildConfigFile, configHelp, findPort, getConfigPorts, getNewPort, isPortUsed, promiseHelp, q, setPort, setPorts;
  if (taskOpts == null) {
    taskOpts = {};
  }
  q = require('q');
  findPort = require('find-port');
  promiseHelp = require(config.req.helpers + "/promise");
  configHelp = require(config.req.helpers + "/config")(config);
  buildConfigFile = false;
  isPortUsed = function(server, openPorts, configPort) {
    var used;
    used = openPorts.indexOf(configPort) === -1;
    if (used && buildConfigFile === false) {
      buildConfigFile = true;
    }
    return used;
  };
  getConfigPorts = function() {
    var port, ports, ref, server;
    ports = [];
    ref = config.ports;
    for (server in ref) {
      port = ref[server];
      ports.push(port);
    }
    return ports;
  };
  getNewPort = function(openPorts) {
    var configPorts, i, len, newPort, openPort;
    configPorts = getConfigPorts();
    newPort = null;
    for (i = 0, len = openPorts.length; i < len; i++) {
      openPort = openPorts[i];
      if (configPorts.indexOf(openPort) === -1) {
        newPort = openPort;
        break;
      }
    }
    return newPort;
  };
  setPort = function(server) {
    var configPort, defer, end, i, range, results, start;
    defer = q.defer();
    configPort = config.ports[server];
    start = configPort;
    end = start + 10;
    range = (function() {
      results = [];
      for (var i = start; start <= end ? i <= end : i >= end; start <= end ? i++ : i--){ results.push(i); }
      return results;
    }).apply(this);
    findPort(range, function(openPorts) {
      var msg, portUsed;
      portUsed = isPortUsed(server, openPorts, configPort);
      if (!portUsed) {
        return defer.resolve();
      }
      config.ports[server] = getNewPort(openPorts);
      msg = server + " port switched to " + config.ports[server] + " because " + configPort + " was in use";
      console.log(msg.yellow);
      return defer.resolve();
    });
    return defer.promise;
  };
  setPorts = function(forTestClientPort) {
    var defer, tasks;
    defer = q.defer();
    switch (!!forTestClientPort) {
      case true:
        tasks = [
          function() {
            return setPort('test');
          }
        ];
        break;
      default:
        if (!config.build.server) {
          return promiseHelp.get(defer);
        }
        if (config.exclude["default"].server.files) {
          return promiseHelp.get(defer);
        }
        tasks = [
          function() {
            return setPort('server');
          }, function() {
            return setPort('reload');
          }, function() {
            return setPort('reloadUI');
          }
        ];
    }
    tasks.reduce(q.when, q()).done(function() {
      return defer.resolve();
    });
    return defer.promise;
  };
  api = {
    runTask: function(loc) {
      var defer, forTestClientPort, tasks;
      defer = q.defer();
      forTestClientPort = loc === 'test:client';
      tasks = [
        function() {
          return setPorts(forTestClientPort);
        }, function() {
          return configHelp.buildFile(buildConfigFile, 'rebuild');
        }
      ];
      tasks.reduce(q.when, q()).done(function() {
        return defer.resolve();
      });
      return defer.promise;
    }
  };
  return api.runTask(taskOpts.loc);
};
