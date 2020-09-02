const router = require('express').Router();
let Workshop = require('../models/workshop.model');

router.route('/').get((req, respo) => {
    Workshop.find()
        .then(workshop => respo.json(workshop))
        .catch(err => respo.status(400).json('Error: '+ err));
});

router.route('/add').post((req, respo) => {
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
    .then(() => respo.json('Workshop added!'))
    .catch(err => respo.status(400).json('Error: '+ err));
})

module.exports = router;