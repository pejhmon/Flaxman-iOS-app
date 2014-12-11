(function() {

	var cordovaRef = window.PhoneGap || window.Cordova || window.cordova;

	var MapKit = function() {
		this.options = {
			height: 460,
			diameter: 1000,
			atBottom: true,
			lat: 49.281468,
			lon: -123.104446
		};

		this.mapType = {
            MAP_TYPE_NONE: 0, //No base map tiles.
            MAP_TYPE_NORMAL: 1, //Basic maps.
            MAP_TYPE_SATELLITE: 2, //Satellite maps with no labels.
            MAP_TYPE_TERRAIN: 3, //Terrain maps.
            MAP_TYPE_HYBRID: 4 //Satellite maps with a transparent layer of major streets.
        };

        this.iconColors = {
            HUE_RED: 0.0,
            HUE_ORANGE: 30.0,
            HUE_YELLOW: 60.0,
            HUE_GREEN: 120.0,
            HUE_CYAN: 180.0,
            HUE_AZURE: 210.0,
            HUE_BLUE: 240.0,
            HUE_VIOLET: 270.0,
            HUE_MAGENTA: 300.0,
            HUE_ROSE: 330.0
        };
	};

	MapKit.prototype = {

		showMap: function(success, error) {
			cordovaRef.exec(success, error, 'MapKit', 'showMap', [this.options]);
		},

		addMapPins: function(pins, success, error) {
			cordovaRef.exec(success, error, 'MapKit', 'addMapPins', [pins]);
		},

		clearMapPins: function(success, error) {
			cordovaRef.exec(success, error, 'MapKit', 'clearMapPins', []);
		},

		hideMap: function(success, error) {
			cordovaRef.exec(success, error, 'MapKit', 'hideMap', []);
		},

		changeMapType: function(mapType, success, error) {
			cordovaRef.exec(success, error, 'MapKit', 'changeMapType', [mapType ? { "mapType": mapType } :{ "mapType": 0 }]);
		}

	};

	cordovaRef.addConstructor(function() {
		window.mapKit = new MapKit();
	});

})();

var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicity call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);

    },
    showMap: function() {
        var pins = [
            {
                lat: 49.28115,
                lon: -123.10450,
                title: "A Cool Title",
                snippet: "A Really Cool Snippet",
                icon: mapKit.iconColors.HUE_ROSE
            },
            {
                lat: 49.27503,
                lon: -123.12138,
                title: "A Cool Title, with no Snippet",
                icon: {
                  type: "asset",
                  resource: "www/img/logo.png", //an image in the asset directory
                  pinColor: mapKit.iconColors.HUE_VIOLET //iOS only
                }
            },
            {
                lat: 49.28286,
                lon: -123.11891,
                title: "Awesome Title",
                snippet: "Awesome Snippet",
                icon: mapKit.iconColors.HUE_GREEN
            }
        ];
        //var pins = [[49.28115, -123.10450], [49.27503, -123.12138], [49.28286, -123.11891]];
        var error = function() {
          console.log('error');
        };
        var success = function() {
          document.getElementById('hide_map').style.display = 'block';
          document.getElementById('show_map').style.display = 'none';
          mapKit.addMapPins(pins, function() { 
                                      console.log('adMapPins success');  
                                      document.getElementById('clear_map_pins').style.display = 'block';
                                  },
                                  function() { console.log('error'); });
        };
        mapKit.showMap(success, error);
    },
    hideMap: function() {
        var success = function() {
          document.getElementById('hide_map').style.display = 'none';
          document.getElementById('clear_map_pins').style.display = 'none';
          document.getElementById('show_map').style.display = 'block';
        };
        var error = function() {
          console.log('error');
        };
        mapKit.hideMap(success, error);
    },
    clearMapPins: function() {
        var success = function() {
          console.log('Map Pins cleared!');
        };
        var error = function() {
          console.log('error');
        };
        mapKit.clearMapPins(success, error);
    },
    changeMapType: function() {
      var success = function() {
          console.log('Map Type Changed');
        };
        var error = function() {
          console.log('error');
        };
        mapKit.changeMapType(mapKit.mapType.MAP_TYPE_SATELLITE, success, error);
    }
};