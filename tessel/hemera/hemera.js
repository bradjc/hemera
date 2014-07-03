var NODE_ID = 20;
var PROFILE = 'TtYWhXKRke';
var GATD    = 'inductor.eecs.umich.edu';
var PORT    = 4001;

var dgram      = require('dgram');
var tessel     = require('tessel');
var ambientlib = require('ambient-attx4');
var climatelib = require('climate-si7005');

var soundevent = false;

var ambient = ambientlib.use(tessel.port['A']);
ambient.on('ready', function () {
  var climate = climatelib.use(tessel.port['B']);
  climate.on('ready', function () {
    setInterval( function () {
      ambient.getLightLevel( function(error, light) {
        ambient.getSoundLevel( function(error, sound) {
          climate.readHumidity( function (error, humidity) {
      	    climate.readTemperature( 'f', function (error, temperature) {
              var message = {
                'id'          : NODE_ID
                'time'        : parseInt(Date.now()),
                'light'       : light,
                'motion'      : soundevent,
                'profile'     : PROFILE,
                'humidity'    : humidity,
                'temperature' : temperature,
              };
              console.log(message);
              soundevent = false;
              ambient.clearSoundTrigger();
              ambient.setSoundTrigger(0.0186);
              var client = dgram.createSocket("udp4");
              client.send(JSON.stringify(message), 0, message.length, PORT, GATD, function(error, bytes) { client.close(); });
            });
      	  });
      	});
      });
    }, 3000);
  });
  climate.on('error', function (error) { console.log( 'CLIMATE MODULE ERROR', err) });
});
ambient.on('sound-trigger', function(data) { soundevent = true });
ambient.on('error', function (error) { console.log( 'AMBIENT MODULE ERROR', err) });
