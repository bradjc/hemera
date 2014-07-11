// REQUIRES
var http       = require('http');
var tessel     = require('tessel');
var ambientlib = require('ambient-attx4');
var climatelib = require('climate-si7005'); // or 'climate-si7020' depending on your module

// MODULE PORTS
var AMBIENT = 'A';
var CLIMATE = 'B';
var MOTION  = 'D';

// HEMERA ATTRIBUTES
var NODE_ID = 20;

// HTTP REQUEST SETUP
var httprequest = {
  host    : 'inductor.eecs.umich.edu',
  port    : 8081,
  path    : '/TtYWhXKRke',
  method  : 'POST',
  headers : {'Content-Type': 'application/json'}
};

// SAMPLE THE MODULES & SEND DATA TO GATD
var ambient = ambientlib.use(tessel.port['A']);
ambient.on('ready', function () {
  var climate = climatelib.use(tessel.port['B']);
  climate.on('ready', function () {
    var motion = tessel.port['D'].digital;
    motion[0].output(0), motion[1].output(1), motion[2].input();
    setInterval( function () {
      ambient.getLightLevel( function(error, light) {
        climate.readHumidity( function (error, humidity) {
    	    climate.readTemperature( 'f', function (error, temperature) {
            var message = {
              id          : NODE_ID,
              time        : parseInt(Date.now()),
              light       : light,
              motion      : motion[2].read(),
              humidity    : humidity,
              temperature : temperature,
            };
            console.log(message);
            try {
              var request = http.request(httprequest);
              request.write(JSON.stringify(message));
              request.end();
              request.on('error', function(error) { console.log('HTTP POST ERROR', error) });  
            } catch (error) { console.log('HTTP REQUEST ERROR', error) }
          });
    	  });
      });
    }, 4000);
  });
  climate.on('error', function (error) { console.log('CLIMATE MODULE ERROR', error) });
});
ambient.on('error', function (error) { console.log('AMBIENT MODULE ERROR', error) });
