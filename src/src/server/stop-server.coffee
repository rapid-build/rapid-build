# server-info is dynamically populated from:
# start-server > build-server-info
# ==========================================
info = require './server-info'
msg  = null

try
	process.kill info.pid
	msg = "Server Stopped on Port #{info.port}"
catch e
	msg = "Failed to Stop the Server: #{e.message}"

console.log msg