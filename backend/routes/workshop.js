const router = require('express').Router();
let Workshop = require('../models/workshop.model');

router.route('/').get((req, res) => {
	Workshop.find()
		.then(workshop => res.json(workshop))
		.catch(err => res.status(400).json('Error: '+ err));
});

router.route('/add').post((req, res) => {
	const id             = req.body.id;
	const name           = req.body.name;
	const dateStart      = req.body.dateStart;
	const dateEnd        = req.body.dateEnd;
	const location       = req.body.location;
	const description    = req.body.description;

	const newWorkshop  = new Workshop({
		id,
		name,
		dateStart,
		dateEnd,
		location,
		description,
	});

		newWorkshop.save()
		.then(() => res.json('Workshop added!'))
		.catch(err => res.status(400).json('Error: '+ err));
})

module.exports = router;