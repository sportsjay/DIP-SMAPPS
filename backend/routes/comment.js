const router = require('express').Router();
let Comment = require('../models/comment.model');

router.route('/').get((req, res) => {
	Comment.find()
		.then(comment => res.json(comment))
		.catch(err => res.status(400).json('Error: '+ err));
});

router.route('/add').post((req, res) => {
	const id            = req.body.id;
	const discussionId  	= req.body.discussionId;
	const text          = req.body.text;

	const newComment  = new Comment({
			id,
			discussionId,
			text
		});

	newComment.save()
		.then(() => res.json('Comment added!'),
			console.log("Comment added successful!"))
		.catch(err => res.status(400).json('Error: '+ err));
})

router.route('/delete/:id').delete((req, res) => {
	const id = req.params.id;
	Comment.remove({ id:id })    
		.then( () => {
			console.log("removed comment id: "+id);
			res.json("Comment id: "+id+" Successfully Deleted!" );
		})
		.catch(err => res.status(400).json('Error: '+err));
	
})

module.exports = router;