const router = require('express').Router();
let Discussion = require('../models/discussion.model');
let Question = require('../models/question.model');
let Answer = require('../models/answer.model');

// Get all discussions // 
router.route('/').get((req, res) => {
	Discussion.find()
		.then(discussions => res.json(discussions))
		.catch(err => res.status(400).json('Error: '+ err));
});

// Get discussion id //
router.route('/:id').get((req, res) => {
	const discussionId = req.params.id;
  Discussion.find({ id: parseInt(discussionId) })
    .then(course => res.json(course))
    .catch(err => res.status(400).json('Error: '+ err));
});

// Add new discussion (course code) note: only accessible by POSTMAN //
router.route('/add').post((req, res) => {

	const id            	= Math.floor(Math.random()*10000);;
	const name          	= req.body.name;
	const countQuestions	= 0;
	const description 		= req.body.description;
	
	const newDiscussion  = new Discussion({
			id,
			name,
			countQuestions,
			description
		});

	newDiscussion.save()
		.then(() => res.json('Discussion added!'))
		.catch(err => res.status(400).json('Error: '+ err));
})

// Delete discussion and all the thread within the discussion //
router.route('/delete/:id').delete((req, res) => {
	const id = req.params.id;
	Discussion.remove({ id:id })    
		.then( () => {
			res.json("Discussion id: "+id+" Successfully Deleted!" );
			Question.remove({ discussionId:id })
			.then( questions => {
				Answer.remove( {discussionId:id })
					.then( answers => {
						res.json("Discussion id: "+ id+ "Successfully removed. "+"Removed "+ 
							questions.deletedCount+ " questions and"+ 
							answers.deletedCount+ "answers")
					})
					.catch(err => res.status(400).json('Error: '+ err));
				
			})
			.catch( err => res.status(400).json('Error:' + err));
		})
		.catch(err => res.status(400).json('Error: '+ err));
})

module.exports = router;