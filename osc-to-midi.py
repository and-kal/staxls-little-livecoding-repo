"""TidalCycles OSC-to-MIDI interceptor

WORK IN PROGRESS

TidalCycles is sending OSC messages through local port 57120. 
Normally Supercollider's SuperDirt is listening on that port.
If you're using TidalCycles for sending out MIDI only, 
SuperCollider is not necessary. So we are interecepting those OSC messages here
and send them to loopMIDI directly.
"""

import argparse
import math
import rtmidi
import time

from pythonosc.dispatcher import Dispatcher
from pythonosc import osc_server

def print_osc_handler(unused_addr, *args):
  try:
    print("{0}".format(
        # OSC messages for CCN and CCV will arrive like this:
        # ['_id_', '1', 'ccn', 8.0, 'ccv', 0.0, 'cps', 0.6416666507720947, 'cycle', 2254.0, 'delta', 1.5584399700164795, 'orbit', 0, 's', 'midi']
        
        # OSC messages for MIDI noteslike this:
        # ['_id_', '1', 'cps', 0.6416666507720947, 'cycle', 2254.0, 'delta', 0.19480499625205994, 'legato', 6.0, 'midichan', 3.0, 'n', -2.0, 'orbit', 0, 's', 'midi']
        args
    ))
  except ValueError: pass

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("--ip",
      default="127.0.0.1", help="The ip to listen on")
  parser.add_argument("--port",
      type=int, default=57120, help="The port to listen on")
  args = parser.parse_args()

  dispatcher = Dispatcher()
  dispatcher.map("/dirt/play", print_osc_handler, "TidalCycles")

  midiout = rtmidi.MidiOut()
  available_ports = midiout.get_ports()

  if available_ports:
    print(f"{available_ports}")
    midiout.open_port(3)

  with midiout:
    note_on = [0x90, 60, 112] # channel 1, middle C, velocity 112
    note_off = [0x80, 60, 0]
    
    i = 0
    while i < 10:
        midiout.send_message(note_on)
        time.sleep(0.035)
        midiout.send_message(note_off)
        time.sleep(0.035)
        i += 1
        
  server = osc_server.ThreadingOSCUDPServer(
      (args.ip, args.port), dispatcher, timeout=10)
  print("Serving on {}".format(server.server_address))
  print("Sending MIDI to {}".format(available_ports[3]))
  server.serve_forever()