///* 
// * To change this license header, choose License Headers in Project Properties.
// * To change this template file, choose Tools | Templates
// * and open the template in the editor.
// */
//
//
//var app = {
//    // Application Constructor
//    initialize: function() {
//        this.bindEvents();
//    },
//    // Bind Event Listeners
//    //
//    // Bind any events that are required on startup. Common events are:
//    // 'load', 'deviceready', 'offline', and 'online'.
//    bindEvents: function() {
//        document.addEventListener('deviceready', this.onDeviceReady, false);
//    },
//    // deviceready Event Handler
//    //
//    // The scope of 'this' is the event. In order to call the 'receivedEvent'
//    // function, we must explicity call 'app.receivedEvent(...);'
//    onDeviceReady: function() {
//        app.receivedEvent('deviceready');
//    },
//    // Update DOM on a Received Event
//    receivedEvent: function(id) {
//        var parentElement = document.getElementById(id);
//        var listeningElement = parentElement.querySelector('.listening');
//        var receivedElement = parentElement.querySelector('.received');
//
//        listeningElement.setAttribute('style', 'display:none;');
//        receivedElement.setAttribute('style', 'display:block;');
//
//        console.log('Received Event: ' + id);
//
//    },
//    showMap: function() {
//        var pins = [
//            {
//                lat: 49.28115,
//                lon: -123.10450,
//                title: "A Cool Title",
//                snippet: "A Really Cool Snippet",
//                icon: mapKit.iconColors.HUE_ROSE
//            },
//            {
//                lat: 49.27503,
//                lon: -123.12138,
//                title: "A Cool Title, with no Snippet",
//                icon: {
//                  type: "asset",
//                  resource: "www/img/logo.png", //an image in the asset directory
//                  pinColor: mapKit.iconColors.HUE_VIOLET //iOS only
//                }
//            },
//            {
//                lat: 49.28286,
//                lon: -123.11891,
//                title: "Awesome Title",
//                snippet: "Awesome Snippet",
//                icon: mapKit.iconColors.HUE_GREEN
//            }
//        ];
//        //var pins = [[49.28115, -123.10450], [49.27503, -123.12138], [49.28286, -123.11891]];
//        var error = function() {
//          console.log('error');
//        };
//        var success = function() {
//          document.getElementById('hide_map').style.display = 'block';
//          document.getElementById('show_map').style.display = 'none';
//          mapKit.addMapPins(pins, function() { 
//                                      console.log('adMapPins success');  
//                                      document.getElementById('clear_map_pins').style.display = 'block';
//                                  },
//                                  function() { console.log('error'); });
//        };
//        mapKit.showMap(success, error);
//    },
//    hideMap: function() {
//        var success = function() {
//          document.getElementById('hide_map').style.display = 'none';
//          document.getElementById('clear_map_pins').style.display = 'none';
//          document.getElementById('show_map').style.display = 'block';
//        };
//        var error = function() {
//          console.log('error');
//        };
//        mapKit.hideMap(success, error);
//    },
//    clearMapPins: function() {
//        var success = function() {
//          console.log('Map Pins cleared!');
//        };
//        var error = function() {
//          console.log('error');
//        };
//        mapKit.clearMapPins(success, error);
//    },
//    changeMapType: function() {
//      var success = function() {
//          console.log('Map Type Changed');
//        };
//        var error = function() {
//          console.log('error');
//        };
//        mapKit.changeMapType(mapKit.mapType.MAP_TYPE_SATELLITE, success, error);
//    }
//};