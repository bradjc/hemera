from phue import Bridge
import random,sys,time

def set_white(light):
  light.brightness = 150
  light.xy = [0,0]

def ack(light):
  light.brightness = 150
  light.xy = [0,0]
  light.on = False
  time.sleep(1)
  light.on = True

def set_purple(light):
  light.brightness = 150
  light.xy = [.3,.2];

def set_red(light):
  light.brightness = 150
  light.xy = [.75,.3];

def set_yellow(light):
  light.brightness = 127
  light.xy = [1,1]

def hue_connect():
  not_connected = True
  while(not_connected):
    try:
      bridge = Bridge('4908hue.eecs.umich.edu')
      bridge.connect()
      not_connected = False
    except:
      print("\nGo push the button on the hub to authorize this program. I'll wait.\n")
      raw_input("Hit enter when you're done. ")
  all_lights = bridge.get_light_objects()
  return all_lights


#lights = hue_connect()
#lights[1].brightness = 10
#ack(lights[1])
#set_yellow(lights[1])
