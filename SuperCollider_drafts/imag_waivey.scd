s.boot;

b = Buffer.alloc(s, 2048, 1);

(
~sig = Signal.fill(1024, {|i| ((i.sin.rand)/(2048)).linlin((0.sin.rand)/2048,(2048.sin.rand)/2048, -1,1)});
	~sig.plot;
)

~wavetable = ~sig.asWavetableNoWrap;

b.loadCollection(~wavetable);

// {Osc.ar(b, mul:EnvGen.ar(Env.perc,doneAction:2))}.play;

(
SynthDef(\trymeout, {|dur|
	Out.ar(0, Splay.ar(LeakDC.ar(Osc.ar(b, SinOsc.ar(0.0025,0,5000,5000), mul:EnvGen.ar(Env.perc(releaseTime:dur),doneAction:2)),0.95)))}
).add;
)

(
Pbind(\instrument, \trymeout,
	\dur, Prand([0.25,0.2,0.3],inf)
).play;
)

c = Buffer.alloc(s, 2048, 1);


(
var sig2, sum, arr, i = 0;

while ({i < 1024}, {
	i = i + 1;
//	~sig2 = Signal.fill(1024, {(Complex(i,3) - Complex(i,4)).exp.imag} );
	sig2 = Array.fill(1024, i*3;
		);
}
sig2.postln;
)
)


~wavetable2 = ~sig2.asWavetable;

b.loadCollection(~wavetable2);

/*
(
var sum, arr, i = 0;
while ({i < 1024}, {
	sum = Complex(i,3) * Complex(i,4);
	i = i + 0.8;
	arr = Array.fill(1, sum);
	arr[0].imag.postln;
})
)

(
var sum, arr, i = 0;
while ({i < 10}, {
	sum = Complex(i,3) * Complex(i,4);
	i = i + 0.8;
	sum.imag.postln;
})
)
*/