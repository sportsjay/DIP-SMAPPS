const mongoose = require('mongoose');
const path = require('path');
const crypto = require('crypto');
const GridFsStorage = require('multer-gridfs-storage');

const url = "mongodb://localhost:27017/SMAPPS-database";

// connect to db
const connectDB = () => {
  mongoose.connect(url, {useNewUrlParser: true});
  const connection = mongoose.connection;
  connection.once('open', () => {
    console.log("MongoDB database connection established successfully");
  });
}

// setup GridFsStorage for images
const storage = new GridFsStorage({
  url: url,
  file: (req, file) => {
    return new Promise((resolve, reject) => {
      crypto.randomBytes(16, (err, buf) => {
        if (err) {
          return reject(err);
        }
        const filename = buf.toString('hex') + path.extname(file.originalname);
        const fileInfo = {
          filename: filename,
          bucketName: 'images'
        };
        resolve(fileInfo);
      });
    });
  }
});

module.exports = { connectDB, storage };