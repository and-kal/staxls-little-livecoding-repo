s.boot
(
SynthDef("teste", {
	arg freq = 20, gate = 1;
	var env, send, phase;
	env = EnvGen.kr(Env([0.01,0.8,1,0.5],[0,0.5,1,1.5],loopNode:0,releaseNode:2),gate);
	phase = LFNoise1.ar(10).range(-0.8,0.8);
	send = Integrator.ar(SinOsc.ar(freq*SinOsc.ar(25).range(20,50),phase,env,0),Line.kr(1,0,1),1,0);
	Out.ar(0,Pan2.ar(send));
}).add;
)

a=Synth("teste");

a.free

(
Pbind(\instrument, "teste",
	\midicps, Pstutter(2, Pseq([4,7,9],inf)),
	\dur, 0.2,
	\amp, 0.5
).play;
)


WiiMote