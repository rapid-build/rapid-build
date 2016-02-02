{<% var cnt = 1; %>
	"name": "<%= name %>",
	"version": "<%= version %>",
	"dependencies": {<% _.forEach(deps, function(version, dep) { %>
		"<%= dep %>": "<%= version %>"<% if (total != cnt++) { %>,<% }}); %>
	}
}