const mongoose = require('mongoose');
const Schema = mongoose.Schema;

let CommentReply = new Schema({
    id: {
        type: Number,
        required: true,
        unique: true
    },
    commentId: {
        type: Number,
        required: true,
        unique: false
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
  
module.exports = mongoose.model('CommentReply', CommentReply);