# server-info is dynamically populated from:
# start-server > build-server-info
# ==========================================
info = require './server-info'
msg  = null

try
	process.kill info.pid
	msg = "Server stopped on port #{info.port}"
catch e
	msg = "Failed to stop the server. #{e.message}"

console.log msg