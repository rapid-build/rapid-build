{<% var cnt = 1; %>
	"name": "rapid-build",
	"version": "<%= version %>",
	"dependencies": {<% _.forEach(deps, function(version, dep) { %>
		"<%= dep %>": "<%= version %>"<% if (total != cnt++) { %>,<% }}); %>
	}
}