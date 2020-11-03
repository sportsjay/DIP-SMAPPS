const router = require('express').Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const verify = require('../functions/verifyToken');

const { registerValidation, loginValidation } = require('../functions/validation');
// const verify = require("")

let User = require('../models/user.model');

// Get all users //
router.route('/').get((req, res) => {
	User.find()
		.then(user => res.json(user))
		.catch(err => res.status(400).json('Error: '+ err));
});

// Get user with id //
router.route('/:id').get(verify, (req, res) => {
	userId = req.params.id;
	User.find({ id: userId })
		.then(user => res.json(user))
		.catch(err => res.status(400).json('Error: '+ err));
})

// User Login // 
router.route('/login').post( async (req, res) => {

	const username = req.body['username'];
	const password = req.body['password'];
	// Validate Data
	const { error } = loginValidation({
		username:username,
		password:password
	});
	if (error) return res.status(400).send(error.details[0].message);
	
	//Check if user exist
	await User.findOne({ username: username })
	.then(async user => {
		if(!user) return res.status(400).send("Invalid Username");
		
		//Password Decrypt
		const validPass = await bcrypt.compare(password, user.password);
		if(!validPass) return res.status(400).send("Invalid Password"); 

		//Create and assign a token
		const token = jwt.sign({id: user.id, username:user.username}, process.env.TOKEN_SECRET);
		res.header('auth-token', token);
		return res.json({
				"notification":"Login Successful!",
				"token":token
			});
		})
	.catch(err => res.status(400).json("Error: "+err));
})

router.route('/logout').post( async (req, res) => {
	req.header('auth-token', "");
	return res.json("Logout successful!");
})

router.route('/register').post( async (req, res) => {

	const id 						= Math.floor(Math.random()*10000);
	const username      = req.body.username;
	const password      = req.body.password;
	const points        = 0;
	const ratedQuestionId = new Array;
	const ratedAnswerId 	= new Array;

	// Validation
	const { error } = registerValidation({
		username: username, 
		password: password
	});
	if(error) return res.status(400).send("Register Error: "+error.details[0].message);

	// Check username exists
	User.findOne({ username: username })
		.then(user => {
			if(user) return res.status(400).send("Username exists! Choose a new unique username");
		})
		.catch(err => res.status(400).json(err));

	// Password Hashing
	const salt = await bcrypt.genSalt(10);
	const hashedPassword = await bcrypt.hash(password, salt);

	const newUser  = new User({
		id,
		username,
		password:hashedPassword,
		points,
		ratedQuestionId,
		ratedAnswerId
	});

	newUser.save()
		.then(() => res.json('user added!'))
		.catch(err => res.status(400).json('Save Error: '+ err));
})

module.exports = router;