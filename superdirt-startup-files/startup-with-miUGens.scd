// install StageMaster Quark
Quarks.install("https://github.com/calumgunn/StageMaster.git");
// then recompile class library

Server.default.options.inDevice_("MME : IN (3- UA-25)");

Server.default.options.outDevice_("MME : OUT (3- UA-25)");

thisProcess.recompile();
// and boot
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
)

// add Mutable Instruments UGens by evaluating these SynthDefs
// https://github.com/v7b1/mi-UGens
// + https://raw.githubusercontent.com/cleary/ansible-tidalcycles-synth-mi-ugens/master/files/mutable-instruments-synthdefs.scd
// + https://raw.githubusercontent.com/cleary/ansible-tidalcycles-synth-mi-ugens/master/files/mutable-instruments-ugens_parameters.hs

(
  SynthDef(\braids, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0,timbre=0.5,color=0.5,model=0|
    var envLength = sustain*(end-begin)/speed;
    var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
    var env = Env.asr;
    var volume = IEnvGen.ar(env, line);
    var sig;

    freq = max(0, freq * speed * (1 + (accelerate * line)));
    sig = MiBraids.ar(pitch: freq.cpsmidi, timbre: timbre, color: color, model: model);

    Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
  }).add;
);

(
  SynthDef(\omi, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0|
    var envLength = sustain*(end-begin)/speed;
    var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
    var env = Env.asr;
    var volume = IEnvGen.ar(env, line);
    var sig;

    freq = max(0, freq * speed * (1 + (accelerate * line)));
    sig = MiOmi.ar(pit: freq.cpsmidi);

    Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
  }).add;
);

(
  SynthDef(\plaits, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0,
      timbre=0.5,engine=0,harm=0.5,morph=0.5,level=1,lpgdecay=0,lpgcolour=0|
    var envLength = sustain*(end-begin)/speed;
    var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
    var env = Env.asr;
    var volume = IEnvGen.ar(env, line);
    var sig;

    freq = max(0, freq * speed * (1 + (accelerate * line)));
    sig = MiPlaits.ar(
      pitch: freq.cpsmidi,
      timbre: timbre,
      harm: harm,
      engine: engine,
      morph: morph,
      level: level,
      decay: lpgdecay,
      lpg_colour: lpgcolour,
    );

    Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
  }).add;
);

(
  SynthDef(\tides, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0,tidesshape=0.5,slope=0.5,tidessmooth=0.5,shift=0.5,mode=2|
    var envLength = sustain*(end-begin)/speed;
    var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
    var env = Env.asr;
    var volume = IEnvGen.ar(env, line);
    var sig;

    freq = max(0, freq * speed * (1 + (accelerate * line)));
    sig = MiTides.ar(
      freq: freq,
      shape: tidesshape,
      slope: slope,
      smooth: tidessmooth,
      shift: shift,
      output_mode: mode,
      ramp_mode: 1,
      rate: 1
    );

    Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
  }).add;
);

(
~dirt.addModule('elements', { |dirtEvent|
	dirtEvent.sendSynth('elements' ++ ~dirt.numChannels,
		[
      elementspitch: ~elementspitch,
      elementsstrength: ~elementsstrength,
      elementscontour: ~elementscontour,
      elementsbowlevel: ~elementsbowlevel,
      elementsblowlevel: ~elementsblowlevel,
      elementsstrikelevel: ~elementsstrikelevel,
      elementsflow: ~elementsflow,
      elementsmallet: ~elementsmallet,
      elementsbowtimb: ~elementsbowtimb,
      elementsblowtimb: ~elementsblowtimb,
      elementsstriketimb: ~elementsstriketimb,
      elementsgeom: ~elementsgeom,
      elementsbright: ~elementsbright,
      elementsdamp: ~elementsdamp,
      elementspos: ~elementspos,
      elementsspace: ~elementsspace,
      elementsmodel: ~elementsmodel,
      elementseasteregg: ~elementseasteregg,
			out: ~out
		]
	)
}, {~elementsstrength.notNil});
);

(
  SynthDef("elements" ++ ~dirt.numChannels, {|out,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0,
      elementspitch=48, elementsstrength=0.5, elementscontour=0.2, elementsbowlevel=0,elementsblowlevel=0, elementsstrikelevel=0,
      elementsflow=0.5, elementsmallet=0.5, elementsbowtimb=0.5, elementsblowtimb=0.5,
      elementsstriketimb=0.5, elementsgeom=0.25, elementsbright=0.5, elementsdamp=0.7, elementspos=0.2, elementsspace=0.3, elementsmodel=0,
      elementseasteregg=0|
    var signal = In.ar(out, ~dirt.numChannels);
    ReplaceOut.ar(out, MiElements.ar(
      blow_in: signal,
      strike_in: signal,
      gate: 1,
      pit: elementspitch,
      strength: elementsstrength,
      contour: elementscontour,
      bow_level: elementsbowlevel,
      blow_level: elementsblowlevel,
      strike_level: elementsstrikelevel,
      flow: elementsflow,
      mallet: elementsmallet,
      bow_timb: elementsbowtimb,
      blow_timb: elementsblowtimb,
      strike_timb: elementsstriketimb,
      geom: elementsgeom,
      bright: elementsbright,
      damp: elementsdamp,
      pos: elementspos,
      space: elementsspace,
      model: elementsmodel,
      easteregg: elementseasteregg
    ));
  }).add;
);

(
~dirt.addModule('mu', { |dirtEvent|
	dirtEvent.sendSynth('mu' ++ ~dirt.numChannels,
		[ mu: ~mu, out: ~out ]
	)
}, {~mu.notNil});
);

(
  SynthDef("mu" ++ ~dirt.numChannels, {|out,mu=0|
    var signal = In.ar(out, ~dirt.numChannels);
    ReplaceOut.ar(out, MiMu.ar(signal, mu));
  }).add;
);

(
~dirt.addModule('rings', { |dirtEvent|
	dirtEvent.sendSynth('rings' ++ ~dirt.numChannels,
		[
			ringstrig: ~ringstrig,
			ringsfreq: ~ringsfreq,
			ringsstruct: ~ringsstruct,
			ringsbright: ~ringsbright,
			ringsdamp: ~ringsdamp,
			ringspos: ~ringspos,
			ringsmodel: ~ringsmodel,
			ringspoly: ~ringspoly,
			ringsinternal: ~ringsinternal,
			ringseasteregg: ~ringseasteregg,
			out: ~out
		]
	)
}, {~ringsbright.notNil});
);

(
SynthDef("rings" ++ ~dirt.numChannels, { |out, ringsfreq=440,ringsstruct=0,ringsbright=0,ringsdamp=0.5,ringspos=0,ringsmodel=0,ringspoly=0,ringsinternal=0,ringseasteregg=0,ringsbypass=0|
	var signal = In.ar(out, ~dirt.numChannels);
	signal = MiRings.ar(
    signal,
    trig: ringsinternal,
    pit: ringsfreq.cpsmidi,
    struct: ringsstruct,
    bright: ringsbright,
    damp: ringsdamp,
    pos: ringspos,
    model: ringsmodel,
    poly: ringspoly,
    intern_exciter: ringsinternal,
    easteregg: ringseasteregg
  );
  ReplaceOut.ar(out, signal)
}).add;

);

(
~dirt.addModule('ripples', { |dirtEvent|
	dirtEvent.sendSynth('ripples' ++ ~dirt.numChannels,
		[
			ripplescf: ~ripplescf,
			ripplesreson: ~ripplesreson,
			ripplesdrive: ~ripplesdrive,
			out: ~out
		]
	)
}, {~ripplescf.notNil});
);

(
SynthDef("ripples" ++ ~dirt.numChannels, { |out, ripplescf=0, ripplesreson=0, ripplesdrive=1|
	var signal = In.ar(out, ~dirt.numChannels);
	signal = MiRipples.ar(
    signal,
    cf: ripplescf,
    reson: ripplesreson,
    drive: ripplesdrive,
  );
  ReplaceOut.ar(out, signal)
}).add;

);


(
~dirt.addModule('warps', { |dirtEvent|
	dirtEvent.sendSynth('warps' ++ ~dirt.numChannels,
		[
			warpsalgo: ~warpsalgo,
			warpstimb: ~warpstimb,
			warpsosc: ~warpsosc,
			warpsfreq: ~warpsfreq,
			warpsvgain: ~warpsvgain,
			warpseasteregg: ~warpseasteregg,
			out: ~out
		]
	)
}, {~warpsalgo.notNil});
);

(
SynthDef("warps" ++ ~dirt.numChannels, { |out, warpsalgo=0, warpstimb=0, warpsosc=1, warpsfreq=440, warpsvgain=1, warpseasteregg=0|
	var signal = In.ar(out, ~dirt.numChannels);
	signal = MiWarps.ar(
    modulator: signal,
    algo: warpsalgo,
    lev1: 1,
    lev2: 1,
    timb: warpstimb,
    osc: warpsosc,
    freq: warpsfreq,
    vgain: warpsvgain,
    easteregg: warpseasteregg
  );
  ReplaceOut.ar(out, signal)
}).add;

);

(

(1..SuperDirt.maxSampleNumChannels).do { |numChannels|

  SynthDef("global_mi_verb" ++ numChannels, { |dryBus, effectBus, verbwet=0, verbtime=0, verbdamp=0, verbhp=0, verbfreeze=0, verbdiff=0.625, verbgain=0|
    var signal = In.ar(dryBus, ~dirt.numChannels);
    Out.ar(effectBus, MiVerb.ar(
      signal,
      verbtime,
      verbwet,
      verbdamp,
      verbhp,
      verbfreeze,
      verbdiff
    ) * verbgain);
  }, [\ir, \ir]).add;

  SynthDef("global_mi_clouds" ++ numChannels, { |dryBus, effectBus, cloudspitch=0, cloudspos=0, cloudssize=0, cloudsdens=0, cloudstex=0, cloudswet=0, cloudsgain=0, cloudsspread=0, cloudsrvb=0, cloudsfb=0, cloudsfreeze=0, cloudsmode=0, cloudslofi=0|
    var signal = In.ar(dryBus, ~dirt.numChannels);
    Out.ar(effectBus, MiClouds.ar(
      inputArray: signal,
      pit: cloudspitch,
      pos: cloudspos,
      size: cloudssize,
      dens: cloudsdens,
      tex: cloudstex,
      drywet: cloudswet,
      in_gain: cloudsgain,
      spread: cloudsspread,
      rvb: cloudsrvb,
      fb: cloudsfb,
      freeze: cloudsfreeze,
      mode: cloudsmode,
      lofi: cloudslofi
    ));
  }, [\ir, \ir]).add;
};

);

// define global effects for mutable instruments effects
(
~dirt.orbits.do { |x|
    var clouds = GlobalDirtEffect(\global_mi_clouds, [\cloudspitch, \cloudspos, \cloudssize, \cloudsdens, \cloudstex, \cloudswet, \cloudsgain, \cloudsspread, \cloudsrvb, \cloudsfb, \cloudsfreeze, \cloudsmode, \cloudslofi]);
    var verb = GlobalDirtEffect(\global_mi_verb, [\verbwet, \verbtime, \verbdamp, \verbhp, \verbfreeze, \verbdiff, \verbgain]);
    x.globalEffects = x.globalEffects
        .addFirst(clouds)
        .addFirst(verb);
    x.initNodeTree;
};
)

