ServerOptions.devices.do({|dev| dev.postln});

Server.default.options.outDevice_("ASIO : JackRouter");
Server.default.options.inDevice_("ASIO : JackRouter");

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
s.options.sampleRate = 44100; // some interfaces might need other values like 48000 (ASIO on Windows defaults to 44100)
// boot the server and start SuperDirt
s.waitForBoot {
~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
~dirt.loadSoundFiles; // load samples (path containing a wildcard can be passed in)
// s.sync; // optionally: wait for samples to be read
~dirt.start(57120, 0 ! 12); // start listening on port 57120, create 12 busses each sending audio to channel 0

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

(
~dirt.loadSoundFiles("C:/Users/Li/Desktop/Livecoding-Repo2024/Staxl-sample-pack/\*");
)

// Evaluate the block below to start the mapping MIDI -> OSC.
// [Sometimes this won't work when Ableton is already running.
// Make sure to disable all MIDI ports in Ableton except loopMIDI.]
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

// chaos synth
(
SynthDef(\gendy3, {
| out, sustain=1, freq=440, max, speed=1, begin=0, end=1, pan, accelerate, offset, volume, ampdist, durdist, cfilt = 20000|
var env = Line.ar(1, 0, sustain, doneAction: Done.freeSelf);
var osc = RLPF.ar(in: Gendy3.ar(ampdist, durdist, freq: freq), freq: cfilt);
osc = Limiter.ar(osc, 0.9);
// Out.ar(0 , osc)
OffsetOut.ar(out,DirtPan.ar(osc, ~dirt.numChannels, pan, env))
}).add;
)

// panic
x.free;

// Evaluate the line below to stop it.
~stopMidiToOsc.value;

// adds light compression, EQ and limiting to all output
// Quarks.install("https://github.com/calumgunn/StageMaster.git");
StageMaster.activate(numChannels: 2, compThreshold: 0.7, limiterLevel: 1.0, highEndDb: 3.0);

// deactivate mastering chain
StageMaster.deactivate;
