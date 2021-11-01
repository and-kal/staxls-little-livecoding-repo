s.boot

(
~xx = SynthDef(\boing, {arg freq=300, dur, plus=0; var env, sig, filter, out, modu;
	env = EnvGen.kr(Env.perc(releaseTime:dur),levelScale:0.5,doneAction:2);
	sig = SinOsc.ar([freq,(freq+plus)],LFNoise0.kr(0.25),env);
	modu = Saw.ar(100,1,2).reciprocal;
	filter = BRF.ar(sig,modu,1);
	out = Out.ar(0, filter)}).add
)

~xx.play

a=Array.series(20,42,2)

(
Pdef(\doing, (
	Pbind(
		\instrument, ~xx,
		\midinote, Prand (a, inf),
		\dur, Prand(Array.rand(10,0.125,0.5),inf),
		\plus, Pseq(Array.series(20, 20, 20), inf)
	)
)
).play;
)

{Saw.ar(5,1,2).reciprocal}.plot(2);