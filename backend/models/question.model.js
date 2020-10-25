const mongoose = require('mongoose');
const Schema = mongoose.Schema;

let Question = new Schema({
    id: {
        type: Number,
        required: true,
        unique: true
    },
    discussionId: {
        type: Number,
        required: true,
        unique: false
    },
    username: {
        type: String,
        required: true,
        unique: false
    },
    text: {
        type: String,
        required: true,
        unique: false
    },
    rating: {
        type: Number,
        required: false,
        unique: false
    }
},{
    timestamps: true,
  });

module.exports = mongoose.model('Question', Question);
