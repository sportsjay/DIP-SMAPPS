const router = require('express').Router();
const verify = require('../functions/verifyToken');
const jwt = require('jsonwebtoken');

let Discussion = require('../models/discussion.model');
let Question = require('../models/question.model');
let Answer = require('../models/answer.model');

// Get all questions //
router.route('/').get((req, res) => {
	Question.find()
		.then(questions => res.json(questions))
		.catch(err => res.status(400).json('Error: '+ err));
});

// Add a question //
router.route('/add').post(verify, (req, res) => {
	const id            = Math.floor(Math.random()*10000);

	const username 			= jwt.decode(req.headers["auth-token"], process.env.TOKEN_SECRET).id;
	const discussionId  = req.body.discussionId;
	const text          = req.body.text;
	const rating 				= 0;
	const countAnswers 	= 0;
	const username 			= jwt.decode(req.headers["auth-token"], process.env.TOKEN_SECRET).username;

	const newQuestion  = new Question({
			id,
			discussionId,
			username,
			text,
			rating,
			countAnswers
		});

	newQuestion.save()
		.then(() => {
			Discussion.findOneAndUpdate({ id:discussionId }, {$inc : {countQuestions:1}})
				.then(() => console.log("Discussion countQuestion Increased Success!"))
				.catch(err => res.json("Error adding countQuestion: "+err));
			res.json('Question added!');})
		.catch(err => res.status(400).json('Error adding question: '+ err));
})

// Add question rating point //
router.route('/:id/rate').get(verify, (req, res) => {
	const questionId		= req.params.id;
	const rate		 			= req.body.rate;
	let point = rate;


	Question.findOneAndUpdate({ id:questionId }, {$inc : {rating:point}})
	.then((question) => 
		{ 
			Discussion.findByIdAndUpdate({ id:question.discussionId }, {$inc : {countQuestions:1}})
				.then(() => console.log("Increase Discussion countQuestion Succes!"))
				.catch(err => res.status(400).json("Error: "+err));
			res.json("Rating Successful!");
		})
	.catch(err => res.status(400).json("Error: "+err));
})

// Add question rating point //
router.route('/:id/rate').get(verify, (req, res) => {
	const questionId		= req.params.id;
	const rate		 			= req.body.rate;
	let point = 0;
	
	rate ? point = 1: point = -1;

	Question.findOneAndUpdate({ id:questionId }, {$inc : {rating:point}})
	.then(() => res.json("Rating Successful!"))
	.catch(err => res.status(400).json("Error: "+err));
})

// Get question for specific course-code //
router.route('/discussion/:id').get((req, res) => {
	const discussionId = req.params.id;
	Question.find({ discussionId:discussionId })
		.then(questions => {
			res.json(questions)
		})
		.catch(err => res.status(400).json('Error: '+ err));
})

// Delete a specific question //
router.route('/delete/:id').delete(verify, (req, res) => {
	const id = req.params.id;
	Question.remove({ discussionId:id })
	.then( question => {
		Discussion.findOneAndUpdate({ id:question.discussionId }, {$inc : { countQuestions:-1 }})
			.then(() => console.log("Decrease countQuestion Success!"))
			.catch(err => res.json("Error: "+err));
		Answer.remove( {discussionId:id })
			.then( answers => {
				res.json("Question id: "+id+"Successfully removed. Removed number of answers: "+ 
					answers.deletedCount)
			})
			.catch(err => res.status(400).json('Error: '+ err));
		
	})
	.catch( err => res.status(400).json('Error:' + err));
})

module.exports = router;