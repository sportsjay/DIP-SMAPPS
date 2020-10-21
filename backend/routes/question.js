const router = require('express').Router();
const verify = require('../functions/verifyToken');
const jwt = require('jsonwebtoken');

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
	const id            = req.body.id;
	const username 			= jwt.decode(req.headers["auth-token"], process.env.TOKEN_SECRET).username;
	const discussionId  = req.body.discussionId;
	const text          = req.body.text;

	const newQuestion  = new Question({
			id,
			discussionId,
			username,
			text
		});

	newQuestion.save()
		.then(() => res.json('Question added!'))
		.catch(err => res.status(400).json('Error: '+ err));
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
	.then( () => {
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