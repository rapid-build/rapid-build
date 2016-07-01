module.exports = server => {
	var app = server.app;

	/* route example
	 ****************/
	app.get('/api/superheroes', (req, res) => {
		res.json(['Superman', 'Wolverine', 'Wonder Woman']);
	});
};