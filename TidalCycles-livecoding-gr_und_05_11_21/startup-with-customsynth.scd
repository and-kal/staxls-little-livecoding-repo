// (based on Platform.userAppSupportDir +/+ "startup.scd")

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
        // for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
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
    s.latency = 0.42; // increase this if you get "late" messages
};
);


// ~dirt.loadSoundFiles("/home/user/.local/share/SuperCollider/downloaded-quarks/Dirt-Samples/");
(
~dirt.loadSoundFiles("/home/user/Desktop/staxls-little-livecoding-repo/Staxl-sample-pack/*");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/BBC/");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/mandalorian_finale/*");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/breaks/*");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/MPC-Drums/");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/Cymatics/");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/RolandTR808/*");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/ESTECDRUMS_samples/");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/RolandTR909/*");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/FreePatsGM/*");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/Sematary_Drumkit/");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/IGLOOGHOST/*");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/SOPHIE_sample_library/*");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/LCBC_samples/*");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/thanks/");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/LEX/*");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/Young-Thug/");
~dirt.loadSoundFiles("/home/user/Desktop/CP-Stxl-tour/samples/_that-i-will-use/GQOM/*");
)

(
SynthDef(\gendy3, {
    | out, sustain=1, freq=440, max, speed=1, begin=0, end=1, pan, accelerate, offset, volume, ampdist, durdist, cfilt = 20000|
    var env    = Line.ar(1, 0, sustain, doneAction: Done.freeSelf);
	var osc    = RLPF.ar(in: Gendy3.ar(ampdist, durdist, freq:freq), freq: cfilt);
	osc = Limiter.ar(osc, 0.9);
	// Out.ar(0 , osc)
	OffsetOut.ar(out,DirtPan.ar(osc, ~dirt.numChannels, pan, env))
}).add;
)
