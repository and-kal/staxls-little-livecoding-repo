// travel along the spine of the spline outputting an x and a y control
{
	# f , w = SplineGen(b,0,loop:true).xyKr(MouseY.kr(0.1,20),32);
	Pulse.ar(f.clip(40,500),w.clip(0.0,1.0),0.4).dup
}.play

b = LinearSpline( Array.fill(60,{ arg i; [ i/10,0.5.rand ] }) );
b.gui(nil,1200@300);

(
SynthDef(\shake, {
	Out.ar(0, Pan2.ar(SinOsc.ar(Dust.kr(5,500,550) * SplineGen(b).kr(doneAction:2)))
	)
}).add;
)


(
SynthDef(\mult, {|midi| var saws;
	saws = Mix.fill(60, {|i|
		PulseDPW.ar(midi.midicps + (i*2.5),rrand(0,1),0, 1/50)
	});
	Out.ar(0, Pan2.ar(
		Compander.ar(FreqShift.ar(saws,
			Saw.kr(10,70,150) * EnvGen.kr(Env.perc(attackTime: 0.3, releaseTime:rrand(1.5,7.5)), doneAction:2)
		),5, MouseX.kr(0.001, 1),clampTime: 0.5
		), SinOsc.kr(rrand(0,25),0).abs
))}).add;
)

(
Pbind(\instrument, \mult,
	\midi, Pseq(Array.rand(20, 30, 100), inf),
	\dur, Pseq(Array.fill(10, {|i| i}),inf)
).play;
)
