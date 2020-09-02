const mongoose = require('mongoose');
const Schema = mongoose.Schema;

let Comment = new Schema({
    id: {
        type: Number,
        required: true,
        unique: true
    },
    text: {
        type: String,
        required: true,
        unique: false
    },
    replies: {
        type: Number
    }
},{
    timestamps: true,
  });
  
module.exports = mongoose.model('Comment', Comment);