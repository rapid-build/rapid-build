module.exports = function(app, config) {
  var i, len, proxies, proxy, proxyMidware, ref;
  proxyMidware = require('http-proxy-middleware');
  proxies = [];
  ref = config.httpProxy;
  for (i = 0, len = ref.length; i < len; i++) {
    proxy = ref[i];
    if (!proxy.context) {
      continue;
    }
    proxies.push(proxyMidware(proxy.context, proxy.options));
  }
  if (!proxies.length) {
    return;
  }
  app.use(proxies);
  return proxyMidware;
};
