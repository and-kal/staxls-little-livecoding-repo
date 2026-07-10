(
ServerOptions.devices.do({|d|
	d.postln;
});
)

// start audio server in PowerShell with:
// `& 'C:\Program Files\JACK2\jackd.exe' -S -p32 -dportaudio -c8 -r44100 -D -C"ASIO::ZOOM U-24 ASIO Driver" -P"ASIO::ZOOM U-24 ASIO Driver"`

(
Server.default.options.outDevice_("ASIO : JackRouter");
Server.default.options.inDevice_("ASIO : JackRouter");

s.reboot { // server options are only updated on reboot
	var cc;
	var osc;
	// configure the sound server: here you could add hardware specific options
	// see http://doc.sccode.org/Classes/ServerOptions.html
	s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples
	s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
	s.options.numWireBufs = 64; // increase this if you get "exceeded number of interconnect buffers" messages
	s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
	s.options.numOutputBusChannels = 2; // set this to your hardware output channel size, if necessary
	s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary
	// boot the server and start SuperDirt
	s.waitForBoot {
		~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
		~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
		// s.sync; // optionally: wait for samples to be read
		~dirt.start(57120, 0 ! 12);   // start listening on port 57120, create two busses each sending audio to channel 0

		// optional, needed for convenient access from sclang:
		(
			~d1 = ~dirt.orbits[0]; ~d2 = ~dirt.orbits[1]; ~d3 = ~dirt.orbits[2];
			~d4 = ~dirt.orbits[3]; ~d5 = ~dirt.orbits[4]; ~d6 = ~dirt.orbits[5];
			~d7 = ~dirt.orbits[6]; ~d8 = ~dirt.orbits[7]; ~d9 = ~dirt.orbits[8];
			~d10 = ~dirt.orbits[9]; ~d11 = ~dirt.orbits[10]; ~d12 = ~dirt.orbits[11];
		);
	};

	s.latency = 0.3; // increase this if you get "late" messages

	s.waitForBoot();

};
);

(
var cc;
var osc;

osc = NetAddr.new("127.0.0.1", 6010);

MIDIClient.init;
// MIDIIn.connectAll;

cc = MIDIFunc.cc({ |val, num, chan, src|
	osc.sendMsg("/ctrl", num.asString, val/127);
});

if (~stopMidiToOsc != nil, {
	~stopMidiToOsc.value;
});

~stopMidiToOsc = {
	cc.free;
};

~midiOut = MIDIOut.newByName("loopMIDI Port", "loopMIDI Port"); // substitute your own device here
~dirt.soundLibrary.addMIDI(\midi, ~midiOut);
)
