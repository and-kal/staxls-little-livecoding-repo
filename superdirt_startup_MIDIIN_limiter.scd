ServerOptions.devices.do({|dev| dev.postln});

Server.default.options.outDevice_("Windows WASAPI : Line (ZOOM U-24 Audio)");
Server.default.options.inDevice_("Windows WASAPI : Line (ZOOM U-24 Audio)");
// Server.default.options.outDevice_("Windows WASAPI : OUT (UA-25)");
// Server.default.options.inDevice_("Windows WASAPI : IN (UA-25)");
// Server.default.options.outDevice_("ASIO : JackRouter");
// Server.default.options.inDevice_("ASIO : JackRouter");
// Server.default.options.outDevice_("Windows WASAPI : Line (2- ZOOM U-24 Audio)");
// Server.default.options.inDevice_("Windows WASAPI : Line (2- ZOOM U-24 Audio)");
// Server.default.options.outDevice_("ASIO : UA-25");
// Server.default.options.inDevice_("ASIO : UA-25");


(
s.reboot { // server options are only updated on reboot
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
};
);

~dirt.loadSoundFiles("C:/Users/Li/Desktop/Verpixelt/Staxl-sample-pack/*");
~dirt.loadSoundFiles("C:/Users/Li/Documents/Ableton/samples/Jungle Jungle - 1989 to 1999 Samplepack/Breaks");
~dirt.loadSoundFiles("C:/Users/Li/Desktop/Verpixelt/gig-exclusive-samples/*");

// Evaluate the block below to start the mapping MIDI -> OSC.
(
var cc;
var osc;

osc = NetAddr.new("127.0.0.1", 6010);

MIDIClient.init;
MIDIIn.connectAll;

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

// test if CC messages arrive
MIDIIn.control = { arg src, chan, num, val;   [chan,num,val/127].postln; }


// Evaluate the line below to stop it.
~stopMidiToOsc.value;

// adds light compression, EQ and limiting to all output
// Quarks.install("https://github.com/calumgunn/StageMaster.git");
StageMaster.activate(numChannels: 2, compThreshold: 0.7, limiterLevel: 1.0, highEndDb: 3.0);

// deactivate light mastering chain
StageMaster.deactivate;
