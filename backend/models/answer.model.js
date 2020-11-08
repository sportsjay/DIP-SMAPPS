const mongoose = require('mongoose');
const Schema = mongoose.Schema;

let Answer = new Schema({
    id: {
        type: Number,
        required: true,
        unique: true
    },
    questionId: {
        type: Number,
        required: true,
        unique: false
    },
    discussionId: {
        type: Number,
        required:true,
        unique:false
    },
    username: {
        type: String,
        required: true,
        unique: false
    },
    rating: {
        type: Number,
        required: false,
        unique: false
    },
    text: {
        type: String,
        required: true,
        unique: false
    },
    img: { 
        type: String,
        required: false,
        unique: false
    },
    userRate: {
        type: Array,
        required: false,
        unique: false
    }
},{
    timestamps: true,
  });
  
module.exports = mongoose.model('Answer', Answer);