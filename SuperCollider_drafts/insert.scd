~tt = List.fill(10, {|i| i*10+1});

~tt = ~tt.linlin(0,100,200,800);


(
SynthDef(\dud, {|dev = 0| Out.ar(0, Pan2.ar(SinOsc.ar([200, (200+dev)], 0, EnvGen.ar(Env.perc(level:0.25),doneAction:2)), SinOsc.ar(0.25)))};
).add;
)

(
Pdef(\nn, Pbind(
	\instrument, \dud,
	\dev, Prand((~tt), inf),
	\dur, Pseq([0.5, (2/3), (1/3)],inf);
)).play;
)

~tt.put(9,(2800*2.02525))

~tt.dump;