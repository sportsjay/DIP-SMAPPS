const router = require('express').Router();
let Comment = require('../models/comment.model');

router.route('/').get((req, respo) => {
    Comment.find()
        .then(comment => respo.json(comment))
        .catch(err => respo.status(400).json('Error: '+ err));
});

router.route('/add').post((req, respo) => {
    const id            = req.body.id;
    const text          = req.body.text;

    const newComment  = new Comment({
        id,
        text
    });

    newComment.save()
    .then(() => respo.json('Comment added!'))
    .catch(err => respo.status(400).json('Error: '+ err));
})

router.route('/delete/:id').delete((req, res) => {
    const id = req.params.id;
    Comment.remove({ id:id })    
        .then( () => {
            console.log("removed comment id: "+id);
            res.json("Comment id: "+id+" Deleted!" );
        })
        .catch(err => res.status(400).json('Error: '+err));
    
})

module.exports = router;