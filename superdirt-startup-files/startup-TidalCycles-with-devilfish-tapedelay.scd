
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
//
    s.latency = 0.3; // increase this if you get "late" messages
};
);

// extra tape delay by devilfish707 (posted on the TidalCycles Discord on Dec 14, 21)
(
var numChannels = s.options.numOutputBusChannels;
SynthDef("dirt_td" ++ numChannels, {|dryBus, effectBus, gate = 1, tdwet = 0.5, tdtime = 0.5, tdfb = 0.1, tdlp = 5000, tdhp = 300, tdwob = 0.01|
    var in, del, filt, sound;
        in = In.ar(dryBus, numChannels).asArray.sum;
        filt = HPF.ar(LPF.ar(in + LocalIn.ar(numChannels), tdlp.clip(50, 20000)), tdhp.clip(30,20000));
            del = DelayL.ar(filt,5,tdtime.clip(0.0001,5)+LFNoise1.kr(1, tdwob.clip(0,1)));
    //    del = del + in;
        del = LeakDC.ar(del);
        LocalOut.ar(del*tdfb);
        sound = del;
        DirtPause.ar(sound, graceTime:4);
        sound = sound * EnvGen.kr(Env.asr, gate, doneAction:2);
    Out.ar(effectBus, sound*tdwet);

},[\ir, \ir]).add
)

(
~dirt.orbits.do {  |x|  var tdel = GlobalDirtEffect("dirt_td", [\tdwet, \tdtime, \tdfb, \tdlp, \tdhp, \tdwob]);
    x.globalEffects = x.globalEffects.addFirst(tdel);
    x.initNodeTree;
    x.set(\fadeTime, 0.01);
	// s.sync;
    };
)

// evaluate this in TidalCycles:
//    tdwet = pF "tdwet"
//    tdtime = pF "tdtime"
//    tdfb = pF "tdfb"
//    tdlp = pF "tdlp"
//    tdhp = pF "tdhp"
//    tdwob = pF "tdwob" 