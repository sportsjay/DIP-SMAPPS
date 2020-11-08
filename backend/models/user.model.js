const mongoose = require('mongoose');
const Schema = mongoose.Schema;

let User = new Schema({
    id: {
        type: Number,
        required: true,
        unique: true
    },
    username: {
        type: String,
        required: true,
        unique: true,
        trim: true,
        minlength: 6
    },
    password: {
        type: String,
        required: true,
        minlength: 6
    },
    points: {
        type: Number,
        required: true,
        unique: false
    }
},{
    timestamps: true,
  });

module.exports = mongoose.model('User', User);
