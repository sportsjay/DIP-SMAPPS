const router = require('express').Router();
const verify = require('../functions/verifyToken');
const jwt = require('jsonwebtoken');

let Answer = require('../models/answer.model');
let User = require('../models/user.model');

// Get all answers //
router.route('/').get((req, res) => {
	Answer.find()
		.then(answers => res.json(answers))
		.catch(err => res.status(400).json('Error: '+ err));
});

// Get specific answer by id //
router.route('/:id').get((req, res) => {
	const AnswerId = req.params.id;
	Answer.find({ id:AnswerId })
		.then(
			answer => res.json(answer)
		)
		.catch(
			err => res.status(400).json("Error: "+err)
		);
})

// Get answers for specific question //
router.route('/question-:id').get((req ,res) => {
	const questionId = req.params.id;
	Answer.find({ questionId:questionId })
		.then(
			answer => res.json(answer)
		)
		.catch(
			err => res.status(400).json("Error: "+err)
		);
})

// Add point to user from answer rating //
router.route(':answerId/add-point-/user/:userid').post(verify, async (req, res) => {
	const id 				= req.params.answerId;	//answer id
	const rating		= req.body.rate;				//rating
	const fromUser 	= jwt.decode(req.headers["auth-token"], process.env.TOKEN_SECRET);
	Answer.findByIdAndUpdate({ id:id }, {$inc : {rating : rating}})
		.then( (answers) => {
			User.findByIdAndUpdate({ id:answers.userId }, {
				$inc : { points : rating } 
			})
				.then(() => {console.log("User Point Updated!");})
				.catch(err => {res.json("Fail to update user point. Error: "+err);});
			User.findByIdAndUpdate({ username:fromUser }, {
				$push : { ratedAnswerId:id }
			})
				.then(() => {console.log("Successfully updated answer rating");})
				.catch(err => res.status(400).json("Error: "+err))
			res.json("Rating Successful!");
		})
		.catch(err => res.status(400).json("Rating Error: "+err));
})

// Add a new answer //
router.route('/add').post(verify, (req, res) => {
	const id            = req.body.id;
	const questionId		= req.body.questionId;
	const discussionId 	= req.body.discussionId;
	const userId 				= jwt.decode(req.headers["auth-token"], process.env.TOKEN_SECRET);
	const rating 				= 0;
	const text          = req.body.text;

	const newAnswer  = new Answer({
		id,
		questionId,
		discussionId,
		userId,
		rating,
		text
	});

	newAnswer.save()
		.then(() => res.json('Answer added!'))
		.catch(err => res.status(400).json('Error: '+ err));
})

// Delete an answer //
router.route('/delete/:id').delete(verify, (req, res) => {
	const id = req.params.id;
	Answer.remove({ id:id })    
		.then( () => res.json("Reply id: "+id+" Successfully Deleted!" ))
		.catch(err => res.status(400).json('Error: '+err));
})

module.exports = router;