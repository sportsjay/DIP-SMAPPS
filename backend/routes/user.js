const router = require('express').Router();
let User = require('../models/user.model');

router.route('/').get((req, res) => {
	User.find()
		.then(user => res.json(user))
		.catch(err => res.status(400).json('Error: '+ err));
});

router.route('/:id').get((req, res) => {
	userId = req.params.id;
	User.find({ id: userId })
		.then(user => res.json(user))
		.catch(err => res.status(400).json('Error: '+ err));
})

router.route('/register').post((req, res) => {
	const id            = req.body.id;
	const username      = req.body.username;
	const password      = req.body.password;
	const points        = 0;

	const newUser  = new User({
		id,
		username,
		password,
		points
	});

	newUser.save()
		.then(() => res.json('user added!'))
		.catch(err => res.status(400).json('Error: '+ err));
})

module.exports = router;