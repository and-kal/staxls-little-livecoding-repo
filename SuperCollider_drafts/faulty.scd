s.boot;

//boundary loop

/*(
Routine({arg jum; if( jum <= 100, {
	jum = jum + 1; 0.1.wait;}, {
	jum = 1};
);

SynthDef(\hmmm, {
	Out.ar(0, Pan2.ar(SinOsc.ar(140+(jum * 40))))};
).add;
});
)

(
~jum = 0;
Routine({if(~jum <= 100, {
	~jum = ~jum + 1}, {
	~jum = 1};
);
0.1.wait;
~jum.println;
});
)
*/

(
SynthDef(\ei, {|yum = 0| Out.ar(0, Pan2.ar(SinOsc.ar(2000+yum,0,EnvGen.ar(Env.perc(level:0.1), doneAction:2),0)));}).add;
)


//endless crescendo
(
r = Routine({ inf.do({|i| Synth(\ei, [\yum, i]);0.125.wait;});
});
)

r.reset;
r.play;

// with if boundary

(
q = Routine({inf.do({|i| if (\yum <= 20, {Synth(\ei, [\yum, (i*10)]);0.125.wait;},
	{Synth(\ei, [\yum, (i*(-10))]);0.125.wait;};
)});
});
)

q.reset;
q.play;

	