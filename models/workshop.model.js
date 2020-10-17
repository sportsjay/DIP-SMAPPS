const mongoose = require('mongoose');
const Schema = mongoose.Schema;

let Workshop = new Schema({
    id: {
        type: Number,
        required: true,
        unique: true
    },
    name: {
        type: String,
        required: true,
        unique: true,
        trim: true,
    },
    dateStart: {
        type: String,
        trim: true
    },
    dateEnd: {
        type: String,
        trim: true
    },
    location: {
        type: String,
        require: true
    },
    description: {
        type: String
    }
},{
    timestamps: true,
  });

module.exports = mongoose.model('Workshop', Workshop);