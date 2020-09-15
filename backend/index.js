const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const cors = require('cors');                                                                                                                              

const url = "mongodb://localhost:27017/SMAPPS-database";
const PORT = 4000; 

app.use(cors());
app.use(bodyParser.json());

mongoose.connect(url, {useNewUrlParser: true});
const connection = mongoose.connection;

connection.once('open', () => {
    console.log("MongoDB database connection established successfully");
});

const eventRouter = require('./routes/event');
const workshopRouter = require('./routes/workshop');
const commentRouter = require('./routes/comment');
const commentReplyRouter = require('./routes/comment_reply');
const userRouter = require('./routes/user');
const discussionRouter = require('./routes/discussion');

app.use('/events-data', eventRouter);
app.use('/workshops-data', workshopRouter);
app.use('/comments-data', commentRouter);
app.use('/reply-data', commentReplyRouter);
app.use('/user', userRouter);
app.use('/discussions-data', discussionRouter);

app.listen(PORT, function() {
    console.log("Server is running on Port: " + PORT);
});
