s.boot;

s.waitForBoot

//b = Buffer.alloc(s,s.sampleRate*2, numChannels:2);
//b = Array.new(100)

//attention - use slashes, not backslashes in the path:
~buffy = SoundFile.collectIntoBuffers("C:/Users/Li/Documents/samples breaks/vk-sample-packs/random/*", s)


~buffy.inspect;


(
SynthDef(\sampler, {|bufnum, rate = 1| var a, read;
	a = PlayBuf.ar(1, bufnum, rate, doneAction:2);
	Out.ar(0, Pan2.ar([a]!2));
}).add;
)

//test sampler
a = Synth(\sampler, [\bufnum, ~buffy, \rate, 0.2]);

//MIDI Out set up


MIDIClient.init;

~midiOut = MIDIOut.newByName("loopMIDI Port", "loopMIDI Port").latency_(Server.default.latency);


//Lindenmayer system based on: https://theseanco.github.io/howto_co34pt_liveCode/3-6-L-Systems-For-Rhythm/
(
~lind = Pseq([Prewrite(1,
        (    1: [1,2,3]/2,
            3/2: [1,5]/6,
		1/6: [1,2,4]/4,
		4/4: 1
), 4)],inf);
)

//playing with it now
(
Pdef(\kiii, Pbind(
	\instrument, \sampler,
	\dur, ~lind*1,
	\bufnum, ~buffy[1],
	\rate, 0.9
)).play(TempoClock(115/60));


Pdef(\snaa, Pbind(
	\instrument, \sampler,
	\dur, (~lind+0.001)*2,
	\bufnum, ~buffy[13],
	\rate, Prand([7, 4, 2, 1.5, 0.8, 0.5],inf)
)).play(TempoClock(115/60));
)


//set to 115bpm
t = TempoClock((85/60/4))

(
~lind2 = Pseq([Prewrite(1,
        (    1: [0.75,1.5,2]/2,
//            1.5/2: [4,12]/8,
//		12/8: [3,4]/4,
		24/32: [6/2,3/4,1/4,0.5/4],
		3/4: [24,12,8,4]/32,
		12/32: [1/3,2/3,1/4,2/4,0.5/4]
), levels:1)],inf);
)

//to inspect your L-system do this:
(
r = ~lind2.asStream;
30.do({ r.next.postln });
)

(
// Pbind(
// 	\type, \midi,
// 	\midiout, ~midiOut,
// 	\chan, 1,
// 	\velocity, 30,
// 	\degree, -13, //MIDI note C3 = 0
// 	\dur, ~lind2
// ).play(t, quant:1);

Pbind(
	\type, \midi,
	\midiout, ~midiOut,
	\chan, 2,
	\degree, (-3),
	\dur, 0.25,
).play(t, quant:1);
//making it explicit (to change levels of Prewrite on-the-fly)

Pdef(\midmid, (Pbind(
    \type, \midi,
    \midiout, ~midiOut,
    \chan, 1,
	\velocity, 30,
//	\degree, Prand([8,2, 5],inf), //MIDI note G3 = 6
	\degree, -10,
    \dur, Pseq([Prewrite(1,
        (    1: [0.75, 1.25, 0.5]/2,
            0.75: [4,2]/8,
		2/8: [2.5]/4,
		2.5/4: [16,8,4]/32,
		8/32: [0.5, 0.25, 0.75, 1.5, 1.25]/2,
		1.25/2: [0.25,0.5, 1.25]/2
), levels:2)],inf)))
).play(t, quant:1);

)

// //live change sample - not working
// (
// fork{
// 	Pdef(~kick).stop;
// 	s.wait;
// 	Pdef(~kick).set(\bufnum, (~buffy[2]));
// 	s.wait;
// 	Pdef(~kick).play;
// }
// )


//Quantisierung funktioniert noch nicht :'|
(
Pdef(\more, Pbind(
	\instrument, \sampler,
	\dur, (~lind+0.01),
	\bufnum, ~buffy[11],
	\rate, (~lind)*4
  )).play(TempoClock(100/60), quant:Quant(2, 0));
)
//Idee - helpfile: t = TempoClock(1); t.schedAbs(t.beats.ceil, { arg beat, sec; [beat, sec].postln; 1 });


Pdef(\sn).stop;

//so much for percussion; now let's play synth
(
SynthDef(\shoo, {
	|degree, fres = 0.5|
	var fmosc, osc, env, out, trig;
	env = EnvGen.ar(Env.perc(level:0.2),doneAction:2);
	fmosc = Saw.ar(0.1,1000,10025);
	osc = AY.ar(degree*100,degree*200,degree*300,0.1,mul:env);
	osc = DFM1.ar(osc, fmosc, fres, mul:0.8);
		out = Out.ar(0, Pan2.ar(osc,SinOsc.ar(0.01)));
}).add;
)

//test it
y = Synth(\shoo)

//and write a L system for it, too (this time with integers b/c we'll play it on a scale)
(
~lind2 = Pseq([Prewrite(1,
        (    1: [1,3,8],
            3: [9,5, 11],
		5: [12,3,2]), 48)],inf);
)


(
p = Pbind(\instrument, \shoo,
	\scale, Scale.kumoi,
	\degree, ~lind2/2,
	\dur, Prand([0.1,0.15,0.2],inf);
).play;
)