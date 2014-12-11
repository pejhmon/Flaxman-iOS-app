// //define model==============================================================
// load mongoose since we need it to define a model
//We will load this model in the app/routes.js file.
var mongoose = require('mongoose');
module.exports = mongoose.model('Artwork', {
    text: String
});