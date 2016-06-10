module.exports = (config, gulp) ->
	q            = require 'q'
	fs           = require 'fs'
	fse          = require 'fs-extra'
	path         = require 'path'
	promiseHelp  = require "#{config.req.helpers}/promise"
	placeholders = {
		'scripts'
		'styles'
		'moduleName' # value for ng-app
		'ngCloakStyles'
		'clickjacking'
	}
	needle =
		comments:
			'BUILD_TEMP_PLACEHOLDER_COMMENT'
		placeholders:
			left: '<!--#include ', right: '-->'

	# helpers
	# =======
	has =
		ph: (content, ph) ->
			content.indexOf(ph) isnt -1

		attr: (attr, content) ->
			content.indexOf(attr) isnt -1

	format =
		phs: (phs) ->
			for key, val of phs
				phs[key] = "#{needle.placeholders.left}#{val}#{needle.placeholders.right}"
			phs

		closing: # last closing tag
			tag: (tag, ph) ->
				return null unless tag
				before = '\n\t'
				after  = '\n'
				"#{before}#{ph}#{after}#{tag}"

		opening: # first opening tag
			tag: (tag, ph) ->
				return null unless tag
				before = '\n\t'
				after  = '\n'
				"#{tag}#{before}#{ph}#{after}"

		before: # first opening tag
			tag: (tag, ph) ->
				return null unless tag
				before = ''
				after  = '\n\n'
				"#{before}#{ph}#{after}#{tag}"

		attr: (tag, ph, attr) ->
			return null unless tag
			lastIndex = tag.lastIndexOf '>'
			tag       = tag.substring(0, lastIndex).trim()
			tag      += " #{attr}=\"#{ph}\">"

	pats =
		closing:
			tag: (tag) ->
				tag        = '.*?' if tag is '*'
				tagPat     = "<\\s*\/\\s*#{tag}\\s*>"
				lastTagPat = '?![\\s\\S]*'
				new RegExp "#{tagPat}(#{lastTagPat}#{tagPat})", 'i'
		opening:
			tag: (tag) ->
				tag = '.*?' if tag is '*'
				new RegExp "<\\s*#{tag}(-->|.|\\s)*?>", 'i'

		before:
			tag: (tag) ->
				pats.opening.tag tag

		comments:
			html:
				new RegExp '<!--(.|\\s)*?-->', 'ig'
			needle:
				new RegExp needle.comments, 'g'

	get =
		content:
			tag: (ph, content, tags) ->
				return content if has.ph content, ph
				for tag, loc of tags
					pat     = pats[loc].tag tag
					locTag  = get.tag pat, ph, loc, content
					continue unless locTag
					content = content.replace pat, locTag
					break
				content

			attr: (ph, attr, content, tags) ->
				return content if has.ph content, ph
				return content if has.attr attr, content
				for tag in tags
					method  = if tag is '*' then 'anyAttr' else 'indAttr'
					info    = get.content[method] ph, attr, content, tag
					continue unless info.oTag
					content = info.content
					break
				content

			indAttr: (ph, attr, content, tag) -> # specific tag
				info = { oTag: null, content }
				pat  = pats.opening.tag tag
				info.oTag = get.attr pat, ph, attr, content # o = opening tag
				return info unless info.oTag
				info.content = info.content.replace pat, info.oTag
				info

			anyAttr: (ph, attr, content, tag) -> # any tag
				info        = { oTag: null, content }
				comments    = []
				pat         = pats.opening.tag tag
				patCmtsHtml = pats.comments.html
				content     = content.replace patCmtsHtml, (cmt) -> comments.push cmt; needle.comments
				info.oTag   = get.attr pat, ph, attr, content # o = opening tag
				return info unless info.oTag
				patCmtsNeedle = pats.comments.needle
				info.content  = content.replace pat, info.oTag
				return info unless comments.length
				cmtCnt = -1
				info.content = info.content.replace patCmtsNeedle, -> cmtCnt++; comments[cmtCnt]
				info

		tag: (pat, ph, loc, content) ->
			match = pat.exec content
			return null unless match
			tag = match[0]
			tag = format[loc].tag tag, ph

		attr: (pat, ph, attr, content) ->
			match = pat.exec content
			return null unless match
			tag = match[0]
			tag = format.attr tag, ph, attr

	# tasks
	# =====
	tasks =
		getContent: (_path) ->
			fs.readFileSync(_path).toString()

		createSpa: (_path, content) ->
			fse.outputFileSync _path, content

		update:
			clickjacking: (content, ph) ->
				get.content.tag(
					ph
					content
					head: 'closing', body: 'closing', '*': 'before'
				)

			scripts: (content, ph) ->
				get.content.tag(
					ph
					content
					body: 'closing', head: 'closing', '*': 'closing'
				)

			styles: (content, ph) ->
				get.content.tag(
					ph
					content
					head: 'closing', body: 'opening', '*': 'before'
				)

			ngCloakStyles: (content, ph) ->
				get.content.tag(
					ph
					content
					head: 'closing', body: 'opening', '*': 'before'
				)

			moduleName: (content, ph) ->
				return content if config.angular.bootstrap.enabled
				get.content.attr(
					ph
					'ng-app'
					content
					['html', 'body', '*']
				)

	autoInject = (type) ->
		injects = config.spa.autoInject
		return true if injects.indexOf('all') isnt -1
		injects.indexOf(type) isnt -1

	# API
	# ===
	api =
		runTask: (spaPath) -> # synchronously
			return promiseHelp.get() unless config.spa.autoInject
			phs     = format.phs placeholders
			content = tasks.getContent spaPath
			content = tasks.update.clickjacking  content, phs.clickjacking  if autoInject 'clickjacking'
			content = tasks.update.styles        content, phs.styles        if autoInject 'styles'
			content = tasks.update.ngCloakStyles content, phs.ngCloakStyles if autoInject 'ngCloakStyles'
			content = tasks.update.scripts       content, phs.scripts       if autoInject 'scripts'
			content = tasks.update.moduleName    content, phs.moduleName    if autoInject 'moduleName'
			tasks.createSpa spaPath, content
			promiseHelp.get()

	# return
	# ======
	api.runTask config.spa.temp.path



