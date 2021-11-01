s.boot

(
SynthDef(\lol,
	{arg freq, out, sawv=4,env, gate=1;
		freq = 1200*Saw.ar(sawv);
//		env = EnvGen.kr(Env.adsr(decayTime:5,releaseTime:5), Impulse.kr(gate));
		out = Out.ar(0,SinOsc.ar(freq,mul:1));
	}
).add;
)

a = Synth.newPaused(\lol)
a.run
a.free
a.set(\sawv, 4, \gate, 5)