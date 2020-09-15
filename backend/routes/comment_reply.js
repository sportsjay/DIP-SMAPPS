const router = require('express').Router();
let CommentReply = require('../models/comment_reply.model');

router.route('/').get((req, res) => {
	CommentReply.find()
		.then(comment => res.json(comment))
		.catch(err => res.status(400).json('Error: '+ err));
});

router.route('/add').post((req, res) => {
	const id            = req.body.id;
	const commentId			= req.body.commentId;
	const text          = req.body.text;

	const newCommentReply  = new CommentReply({
		id,
		commentId,
		text
	});

	newCommentReply.save()
		.then(() => res.json('Reply added!'),
			console.log("Reply added successful!"))
		.catch(err => res.status(400).json('Error: '+ err));
})

router.route('/delete/:id').delete((req, res) => {
	const id = req.params.id;
	CommentReply.remove({ id:id })    
		.then( () => {
			console.log("removed reply id: "+id);
			res.json("Reply id: "+id+" Successfully Deleted!" );
		})
		.catch(err => res.status(400).json('Error: '+err));
	
})

module.exports = router;