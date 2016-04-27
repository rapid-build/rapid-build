# DEPLOY DOCS
# deploy = master | latest tag
# ============================
module.exports = (docsRoot, deploy) ->
	path    = require 'path'
	exec    = require('child_process').exec
	helpers = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs = require "#{helpers}/buffer-msgs"
	log     = require "#{helpers}/log"
	HOST    = require(path.join docsRoot, 'scripts', 'constants').host
	cnt     = 1
	needle  = 'unexpected error' # random gandi error at beginning of deploy
	cmd     = "ssh #{HOST.login}@git.#{HOST.datacenter}.gpaas.net "
	cmd    += "'deploy #{HOST.vhost}.git #{deploy}'"

	# tasks
	# =====
	deployTask = ->
		new Promise (resolve, reject) ->
			exec cmd, {}, (e, stdout, stderr) ->
				msgs = bufMsgs.get e, stdout, stderr
				return reject msgs.e if e
				res  = msgs.stds
				resolve res

	runTask = ->
		new Promise (resolve, reject) ->
			deployTask().then (res) ->
				if cnt is 5
					msg = "Docs Deployment Failed from #{deploy}. #{needle}"
					return reject msg

				else if res.indexOf('Aborting deployment') != -1
					return reject res

				else if res.indexOf(needle) != -1
					cnt++
					log "Redeploy CNT #{cnt}"
					console.log res
					return runTask()

				else
					resolve "Docs Deployed from #{deploy}"

			.catch (e) ->
				reject e

	# run it!
	# =======
	runTask()





