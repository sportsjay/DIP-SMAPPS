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
})

const eventRouter = require('./routes/event');
const workshopRouter = require('./routes/workshop');
const commentRouter = require('./routes/comment');

app.use('/events-data', eventRouter);
app.use('/workshops-data', workshopRouter);
app.use('/comments-data', commentRouter);

app.listen(PORT, function() {
    console.log("Server is running on Port: " + PORT);
});
