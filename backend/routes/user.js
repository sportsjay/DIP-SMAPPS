const router = require('express').Router();
let User = require('../models/user.model');

router.route('/').get((req, respo) => {
    User.find()
        .then(user => respo.json(user))
        .catch(err => respo.status(400).json('Error: '+ err));
});

router.route('/register').post((req, respo) => {
    const id            = req.body.id;
    const username      = req.body.username;
    const password      = req.body.password;
    const comments      = req.body.comment;

    const newUser  = new User({
        id,
        username,
        password,
        comments

    });

    newUser.save()
    .then(() => respo.json('user added!'))
    .catch(err => respo.status(400).json('Error: '+ err));
})

module.exports = router;