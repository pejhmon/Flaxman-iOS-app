//========================== set up ===============================================

var express           = require('express'),
    app               = express(),
    bodyParser        = require('body-parser'),
    mongoose          = require('mongoose'),
    meetupsController = require('./server/controllers/meetups-controller');

var port = process.env.PORT || 3000;

//========================= config ==========================

//mongoose.connect('mongodb://localhost:27017/mean-demo');
mongoose.connect('mongodb://emettely:19902apple@ds055680.mongolab.com:55680/artdb');
app.use(bodyParser());
app.get('/', function (req, res) {
  res.sendfile(__dirname + '../searchresults.html');
});
app.use('/js', express.static(__dirname + '/searchtest'));

//define model==============================================================

var Todo = mongoose.model('Todo', {
   text : String,
   done : Boolean
    
});

// routes ===========================================================================
    //REST API===================
app.get('/api/meetups', meetupsController.list);
app.post('/api/meetups', meetupsController.create);

app.listen(3000, function() {
  console.log('I\'m Listening...');
});