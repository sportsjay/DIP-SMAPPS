const router = require('express').Router();
let Discussion = require('../models/discussion.model');
let Comment = require('../models/comment.model');
let CommentReply = require('../models/comment_reply.model');

router.route('/').get((req, res) => {
	Discussion.find()
		.then(comment => res.json(comment))
		.catch(err => res.status(400).json('Error: '+ err));
});

router.route('/:id/comments').get((req, res) => {
  const discussionId = req.params.id;
  Discussion.find({ id: discussionId })
    .then( () => {
			Comment.find({ discussionId:discussionId })
				.then(comments => {
					CommentReply.find( {discussionId:discussionId })
						.then(commentReplies => {
							data = new Array;
							comments.map(comment => {
								let temp = comment;
								temp.replies = new Array;
								data.push(temp);
								console.log(temp);
								commentReplies.map(commentReply => {
									if( commentReply['commentId'] === comment['id'] ){
										data[-1].push(commentReply)
									}
								})
							})
							res.json(data);
						})
						.catch(err => res.status(400).json('Error: '+ err));
				})
				.catch(err => res.status(400).json('Error: '+ err));
		})
    .catch(err => res.status(400).json('Error: '+ err));
});

router.route('/:id').get((req, res) => {
  const discussionId = req.params.id;
  Discussion.find({ id: discussionId })
    .then(thread => res.json(thread))
    .catch(err => res.status(400).json('Error: '+ err));
});

router.route('/add').post((req, res) => {
	const id            = req.body.id;
	const name          = req.body.name;

	const newDiscussion  = new Discussion({
			id,
			name
		});

	newDiscussion.save()
		.then(() => res.json('Thread added!'),
			console.log("Thread added successful!"))
		.catch(err => res.status(400).json('Error: '+ err));
})

router.route('/delete/:id').delete((req, res) => {
	const id = req.params.id;
	Discussion.remove({ id:id })    
		.then( () => {
			console.log("removed Thread id: "+id);
			// res.json("Thread id: "+id+" Successfully Deleted!" );
			Comment.remove({ discussionId:id })
			.then( comment => {
				console.log("removed comments: "+comment.deletedCount);
				CommentReply.remove( {discussionId:id })
					.then( commentReply => {
						res.json("Thread id: "+ id+ "Successfully removed. "+"Removed "+ 
							comment.deletedCount+ " data and replies: "+ 
							commentReply.deletedCount)
					})
					.catch(err => res.status(400).json('Error: '+ err));
			})
			.catch( err => res.status(400).json('Error:' + err));
		})
		.catch(err => res.status(400).json('Error: '+ err));
})

module.exports = router;