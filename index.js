const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');


const url = "mongodb://localhost:27017/SMAPPS-database";
const PORT = 4000; 

app.use(cors());
app.use(bodyParser.json());

dotenv.config();

// Connect DB
mongoose.connect(url, {useNewUrlParser: true});
const connection = mongoose.connection;

connection.once('open', () => {
    console.log("MongoDB database connection established successfully");
});

//Route MiddleWare
const eventRouter = require('./routes/event');
const workshopRouter = require('./routes/workshop');
const commentRouter = require('./routes/question');
const commentReplyRouter = require('./routes/answer');
const userRouter = require('./routes/user');
const discussionRouter = require('./routes/discussion');

app.use('/user', userRouter);
app.use('/events-data', eventRouter);
app.use('/workshops-data', workshopRouter);
app.use('/questions-data', commentRouter);
app.use('/answers-data', commentReplyRouter);
app.use('/discussions-data', discussionRouter);

app.listen(PORT, function() {
    console.log("Server is running on Port: " + PORT);
});
