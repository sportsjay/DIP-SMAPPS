const mongoose = require('mongoose');
const Schema = mongoose.Schema;

let Discussion = new Schema({
    id: {
        type: Number,
        required: true,
        unique: true
    },
    name: {
        type: String,
        required: true,
        unique: true
    },
    countQuestions: {
        type: Number,
        required: false,
        unique: false
    },
    description: {
        type: String,
        required: false,
        unique: false
    }
},{
    timestamps: true,
  });
  
module.exports = mongoose.model('Discussion', Discussion);