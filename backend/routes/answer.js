const router = require('express').Router();
// Routing verification //
const verify = require('../functions/verifyToken');
const jwt = require('jsonwebtoken');
// Upload Files //
const multer = require('multer');
const Grid = require('gridfs-stream');
const mongoose = require('mongoose');
const { storage } = require('./db.route');
// Schema imports //
let Question = require('../models/question.model');
let Answer = require('../models/answer.model');
let User = require('../models/user.model');


const conn = mongoose.createConnection(process.env.MONGO_URI);
// Init gfs
let gfs;
conn.once('open', () => {
  // Init stream
  gfs = Grid(conn.db, mongoose.mongo);
  gfs.collection('images');
});

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
		.then((answers) => {
			res.json(answers);	
		})
		.catch(
			err => res.status(400).json("Error: "+err)
		);
})

// Get pictures/files for answer //
router.route('/files/:img_name').get((req, res) => {
	const fileName = req.params.img_name;
	gfs['files'].find({ filename:fileName }).toArray((err, images) => {
		images.map( image => {
			if (image.contentType === 'image/jpeg' || image.contentType === 'image/png') {
				// Read output to browser
				const readstream = gfs.createReadStream(image.filename);
				readstream.pipe(res);
			}
			else {
				res.status(404).json({err: 'Not an image'});
			}
		})
	})
})

// Get answers for specific question //
router.route('/question/:id').get((req ,res) => {
	const questionId = req.params.id;
	let response = new Array;
	Answer.find({ questionId:questionId })
		.then((answers) => {
			answers.map( answer => {
				response.push(answer);
				if(answer.img) {
					gfs.files.find({ filename:answer.img }).toArray((err, files) => {
					})
				}
			})
		})
		.then( () => { res.json(response) })
		.catch(err => res.status(400).json("Error: "+err));
})

// Add point to user from answer rating //
router.route('/rate/:answerId').post(verify, async (req, res) => {
	const fromUser 	= jwt.decode(req.headers["auth-token"], process.env.TOKEN_SECRET).username;
	const answerId 	= req.params.answerId;	//answer id
	const rating		= req.body.rate;				//rating

	let point;
	rating ? point = 1: point = -1;
	if(rating) {
		Answer.findOneAndUpdate({ id:answerId }, {$inc : { rating:point }, $push: { userRate:fromUser }})
			.then( async (answer) => {
				// Increase the points of the user who posted the answer
				await User.findOneAndUpdate({ username:answer.username }, {
					$inc : { points:rating }
				})
					.then(() => console.log("User Point Updated!"))
				res.json("Rating Successful!");
			})
			.catch(err => res.status(400).json("Rating Error: "+err));

		// 	.catch(err => res.status(400).json("Fail to update user point. Error: "+err));
	} else {
		Answer.findOneAndUpdate({ id:answerId }, {$inc : { rating:point }, $pull : { userRate:fromUser }})
			.then( async (answer) => {
				// Increase the points of the user who posted the answer
				await User.findOneAndUpdate({ username:answer.username }, {
					$inc : { points:rating }
				})
					.then(() => console.log("User Point Updated!"))
				res.json("Rating Successful!");
			})
			.catch(err => res.status(400).json("Rating Error: "+err));
	}
})

// Add a new image //
// creates an upload middleware to process files in form of jpg, jpeg, png
const upload = multer({ storage: storage }); 
router.route('/add-img').post(verify, upload.single('img'), (req, res) => {

	const img		 				= req.file.filename;
	const id            = Math.floor(Math.random()*10000);;
	const questionId		= req.body.questionId;
	const discussionId 	= req.body.discussionId;
	const username 			= jwt.decode(req.headers["auth-token"], process.env.TOKEN_SECRET).username;
	const rating 				= 0;
	const text          = req.body.text;
	const userRate			= [];

	const newAnswer  = new Answer({
		id,
		questionId,
		discussionId,
		username,
		rating,
		text,
		img,
		userRate
	});

	console.log("text: "+text);
	newAnswer.save()
	.then(() => {
		Question.findOneAndUpdate({ id:questionId }, {$inc: {countAnswers:1}})
			.then(() => console.log("Question countAnswers Increased Success!"))
			.catch(err => res.json("Error: "+err));
		res.json('Answer added!');
	})
	.catch(err => res.status(400).json('Error: '+ err));
})

// Add a new answer without img //
router.route('/add').post(verify, (req, res) => {
	const id            = Math.floor(Math.random()*10000);;
	const questionId		= req.body.questionId;
	const discussionId 	= req.body.discussionId;
	const username 			= jwt.decode(req.headers["auth-token"], process.env.TOKEN_SECRET).username;
	const rating 				= 0;
	const text          = req.body.text;
	const userRate			= [];

	const newAnswer  = new Answer({
		id,
		questionId,
		discussionId,
		username,
		rating,
		text,
		userRate
	});

	newAnswer.save()
	.then(() => {
		Question.findOneAndUpdate({ id:questionId }, {$inc: {countAnswers:1}})
			.then(() => console.log("Question countAnswers Increased Success!"))
			.catch(err => res.json("Error: "+err));
		res.json('Answer added!');
	})
	.catch(err => res.status(400).json('Error: '+ err));
})

// Delete an answer //
router.route('/delete/:id').delete(verify, (req, res) => {
	const id = req.params.id;
	Answer.remove({ id:id })    
		.then( answer => {
			Question.findOneAndUpdate({ id:answer.questionId }, {$inc : {countAnswers:-1}})
				.then(() => console.log("Question countAnswer Decreased Success!"))
				.catch(err => res.json("Error: "+err));
			res.json("Reply id: "+id+" Successfully Deleted!" );
		})
		.catch(err => res.status(400).json('Error: '+err));
})

module.exports = router;