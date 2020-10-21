const router = require('express').Router();
let Discussion = require('../models/discussion.model');
let Question = require('../models/question.model');
let Answer = require('../models/answer.model');
let User = require('../models/user.model');

// Get all discussions // 
router.route('/').get((req, res) => {
	Discussion.find()
		.then(discussions => res.json(discussions))
		.catch(err => res.status(400).json('Error: '+ err));
});

// Get thread from discussion and all the specific questions and answers //
// router.route('/:id/thread').get((req, res) => {
// 	const discussionId = req.params.id;
// 	data = new Array;
//   Discussion.find({ id: discussionId })
//     .then( () => {
// 			Question.find({ discussionId:discussionId })
// 				.then(questions => {
// 					Answer.find( {discussionId:discussionId })
// 						.then(answers => {
// 							questions.map(question => {
// 								data.push([question]); // append comment with discussionid 
// 									answers.map(answer => {
// 									if( answer['commentId'] === question['id'] ){
// 										data[data.length-1].push(answer); // append to the current reply with commentid = id of comment
// 									}
// 								})
// 							})
// 							return res.json(data);
// 						})
// 						.catch(err => res.status(400).json('Error: '+ err));
// 				})
// 				.catch(err => res.status(400).json('Error: '+ err));
// 		})
//     .catch(err => res.status(400).json('Error: '+ err));
// });

// Get discussion id //
router.route('/:id').get((req, res) => {
  const discussionId = req.params.id;
  Discussion.find({ id: discussionId })
    .then(thread => res.json(thread))
    .catch(err => res.status(400).json('Error: '+ err));
});

// Add new discussion (course code) note: only accessible by admins //
router.route('/add').post((req, res) => {
	const id            = req.body.id;
	const name          = req.body.name;
	
	const newDiscussion  = new Discussion({
			id,
			name
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