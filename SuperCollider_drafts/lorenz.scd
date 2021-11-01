(
{Pan2.ar(
	FreeVerb.ar(
		AY.ar(
	3000*(LorenzL.ar(0.75,200,10,4.5)),
	4000*(LorenzL.ar(90)),
	2500*(LorenzL.ar(10)),
			noise:0, chiptype:1
),
		mix:0.5,room:0.1,damp:0.9
))}.play;
)


(
SynthDef(\manymany, {
	|freq = 400, dur=0.5, detuner = 5, counter = 10|
	var env, sig;
	env = EnvGen.ar(Env.perc(attackTime:0.01,level:1/10,releaseTime:dur),doneAction:2);
	sig = Mix.fill(10, {|i|
		SinOsc.ar(freq*((detuner/i)*0.5))
	});
	sig = Out.ar(0, Pan2.ar(sig*env,LFNoise2.kr(0.001)));
	}
).add;
)

(
Pbind(\instrument, \manymany,
	\freq, Pxrand(Array.geom(48,700,1.01),inf),
	\dur, Pwrand([1.25,0.25,0.5]/2,[1,11,2].normalizeSum,inf)
).play(quant:1);
)