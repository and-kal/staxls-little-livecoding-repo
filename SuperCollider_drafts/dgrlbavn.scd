
(
SynthDef(\justsosimple, {|freq, dur, modamount|
	Out.ar(0, Pan2.ar(
		FreeVerb.ar(
		Mix.fill(20,{
			|i| SinOsc.ar(1200-(freq+((i*7.5)**modamount)),mul:EnvGen.ar(Env.perc(releaseTime:dur,level:0.05),doneAction:2))

	}),
			room:0.7,damp:0.5,mix:0.25
		)
	))
}
).add;
)


(
Pbind(
	\instrument, \justsosimple,
	\freq, Pseq("Ich rieche nach Knoblauch und Bier 💕.".ascii.linlin(-110,110,60,85).round.midicps, inf),
	\dur, Prand([0.125,0.25,(1/3)]*3 ++ [Rest(0.125)],inf),
	\modamount, Prand(Array.rand(16,0.51,1.10),inf);
).play;
)

