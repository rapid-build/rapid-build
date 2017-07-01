# SRC HELPER
# ==========
exec = require('child_process').exec
log  = require './log'

# module
# ======
module.exports =
	installServer: (verbose=false) -> # :promise<boolean>
		new Promise (resolve, reject) ->
			cmd = 'npm run npm-install-server' # defined in package.json
			exec cmd, (err, stdout, stderr) ->
				return reject err if err
				log.msg "installed server src packages"
				if verbose then try
					output = "#{stdout.trim()}\n\n#{stderr.trim().warn}"
					log.msgWithSeps 'stdout and stderr', 'minor'
					log.msgWithSeps output, 'minor', false, true, false, 78
				resolve true

	uninstallServer: (verbose=false) -> # :promise<boolean>
		new Promise (resolve, reject) ->
			cmd = 'npm run npm-uninstall-server' # defined in package.json
			exec cmd, (err, stdout, stderr) ->
				return reject err if err
				log.msg "uninstalled server src packages"
				if verbose then try
					output = "#{stdout.trim()}\n\n#{stderr.trim().warn}"
					log.msgWithSeps 'stdout and stderr', 'minor'
					log.msgWithSeps output, 'minor', false, true, false, 78
				resolve true