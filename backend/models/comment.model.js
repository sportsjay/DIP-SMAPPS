const mongoose = require('mongoose');
const Schema = mongoose.Schema;

let Comment = new Schema({
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
    text: {
        type: String,
        required: true,
        unique: false
    }
},{
    timestamps: true,
  });

module.exports = mongoose.model('Comment', Comment);