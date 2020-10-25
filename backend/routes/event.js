const router = require('express').Router();
let Event = require('../models/event.model');

router.route('/').get( async (req, res) => {
	Event.find()
		.then(event => res.json(event))
		.catch(err => res.status(400).json('Error: '+ err));
});

router.route('/add').post( async (req, res) => {
	const id            = Math.floor(Math.random()*10000);
	const name          = req.body.name;
	const dateStart     = req.body.dateStart;
	const dateEnd       = req.body.dateEnd;
	const location      = req.body.location;
	const description   = req.body.description;

	const newEvent  = new Event({
		id,
		name,
		dateStart,
		dateEnd,
		location,
		description,
	});
	await newEvent.validate()
		.then()
	newEvent.save()
		.then(() => res.json('Event added!'))
		.catch(err => res.status(400).json('Error: '+ err));
})

module.exports = router;

    
