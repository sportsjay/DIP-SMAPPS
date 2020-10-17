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
    }
},{
    timestamps: true,
  });
  
module.exports = mongoose.model('Discussion', Discussion);