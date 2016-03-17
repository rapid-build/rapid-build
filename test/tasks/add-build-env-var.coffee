# TECHNIQUE FOR RUNNING BUILD TASKS FOR SPECIFIC MODES
# ====================================================
module.exports = (config) ->
	process.env.RB_MODE = config.build.mode