//========================== set up ===============================================

var express = require('express');
var app = express();                                                        //create app with express
var bodyParser = require('body-parser');                                    //pull info from HTML post
var mongoose = require('mongoose');                                         //mongoose for mongodb
//var meetupsController = require('./server/controllers/meetups-controller'); //!!!!
var port = process.env.PORT || 3000;                                        //setport
var database = require('./config/database');                                // load config
var morgan = require('morgan');                                             // log requests to the console (express)
var methodOverride = require('method-override');                            // simulate DELETE and PUT (express4)

// configuration ===============================================================

mongoose.connect(database.url);     // connect to mongoDB database on modulus.io !- mongolabs

app.use('/js', express.static(__dirname + '/searchtest'));
app.use(bodyParser());
app.use(morgan('dev'));                                                     // log every request to the console
app.use(bodyParser.urlencoded({'extended': 'true'}));                       // parse application/x-www-form-urlencoded
app.use(bodyParser.json());                                                 // parse application/json
app.use(bodyParser.json({type: 'application/vnd.api+json'}));               // parse application/vnd.api+json as json
app.use(methodOverride());


//REST API===================
//app.get('/api/artwork', meetupsController.list);
//app.post('/api/artworks', meetupsController.create);

// load the single view file (angular will handle the page changes on the front-end)
app.get('*', function (req, res) {
    res.sendfile('../searchresults.html');
});


// listen (start app with node server.js)=============================================
app.listen(port);
console.log('I\'m Listening...' + port);

// load the routes
require('./app/routes')(app);