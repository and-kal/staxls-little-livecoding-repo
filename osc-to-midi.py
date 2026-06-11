"""TidalCycles OSC-to-MIDI interceptor

TidalCycles is sending OSC messages through local port 57120. 
Normally Supercollider's SuperDirt is listening on that port.
If you're using TidalCycles for sending out MIDI only, 
SuperCollider is not necessary. So we are interecepting those OSC messages here
and send them to loopMIDI directly.
"""

import argparse
import math

from pythonosc.dispatcher import Dispatcher
from pythonosc import osc_server

def print_volume_handler(unused_addr, args, volume):
  print("[{0}] ~ {1}".format(args[0], volume))

def print_compute_handler(unused_addr, args, volume):
  try:
    print("[{0}] ~ {1}".format(args[0], args[1](volume)))
  except ValueError: pass

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("--ip",
      default="127.0.0.1", help="The ip to listen on")
  parser.add_argument("--port",
      type=int, default=57120, help="The port to listen on")
  args = parser.parse_args()

  dispatcher = Dispatcher()
  dispatcher.map("/filter", print)
  dispatcher.map("/volume", print_volume_handler, "Volume")
  dispatcher.map("/logvolume", print_compute_handler, "Log volume", math.log)

  server = osc_server.ThreadingOSCUDPServer(
      (args.ip, args.port), dispatcher, timeout=10)
  print("Serving on {}".format(server.server_address))
  server.serve_forever()