/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

// routes ======================================================================

	// api ---------------------------------------------------------------------
	// get all todos
	app.get('/api/artworks', function(req, res) {

		// use mongoose to get all todos in the database
		Artwork.find(function(err, artworks) {

			// if there is an error retrieving, send the error. nothing after res.send(err) will execute
			if (err)
				res.send(err)

			res.json(artworks); // return all todos in JSON format
		});
	});
//
//	// create todo and send back all todos after creation
//	app.post('/api/todos', function(req, res) {
//
//		// create a todo, information comes from AJAX request from Angular
//		Todo.create({
//			text : req.body.text,
//			done : false
//		}, function(err, todo) {
//			if (err)
//				res.send(err);
//
//			// get and return all the todos after you create another
//			Todo.find(function(err, todos) {
//				if (err)
//					res.send(err)
//				res.json(todos);
//			});
//		});
//
//	});

	// delete a todo
//	app.delete('/api/todos/:todo_id', function(req, res) {
//		Todo.remove({
//			_id : req.params.todo_id
//		}, function(err, todo) {
//			if (err)
//				res.send(err);
//
//			// get and return all the todos after you create another
//			Todo.find(function(err, todos) {
//				if (err)
//					res.send(err)
//				res.json(todos);
//			});
//		});
//	});


