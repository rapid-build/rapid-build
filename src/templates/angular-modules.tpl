# Do not check this file in.
# It gets generated from /templates/angular-modules.tpl
# =====================================================
angular.module '<%= moduleName %>', [<% _.forEach(modules, function(module) { %>
	'<%= module %>'<% }); %>
] if typeof angular isnt 'undefined'