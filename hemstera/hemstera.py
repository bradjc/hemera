import sys, hue, time, urllib
import socketIO_client as sioc

SOCKETIO_HOST      = 'inductor.eecs.umich.edu'
SOCKETIO_PORT      = 8082
SOCKETIO_NAMESPACE = 'stream'

query = {'profile_id': 'TtYWhXKRke',
         'motion'    : True,
         'id'        : 4}

#Globals
max_brightness = 250 #max value of lamp given by phue
bulb_name = sys.argv[1]

# Connect to hue
lights = hue.hue_connect()
light = [l for l in lights if l.name == bulb_name][0]

hist = '0'

class stream_receiver (sioc.BaseNamespace):
	def on_connect (self):
		stream_namespace.emit('query', query)
		light.on = True

	def on_data (self, *args):
		# light.on = True
		light.xy = [.75,.3];
		light.brightness = max_brightness
		time.sleep(2)
		light.brightness = 0
		#light.on = False

	# def run_light (self):
	#	time.sleep(.1);
	#	light.brightness -= 1
		
socketIO = sioc.SocketIO(SOCKETIO_HOST, SOCKETIO_PORT)
stream_namespace = socketIO.define(stream_receiver,
	'/{}'.format(SOCKETIO_NAMESPACE))

socketIO.wait()
