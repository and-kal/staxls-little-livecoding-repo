s.boot;

(
Ndef(\rong, {
	var out, env, trig, fx;
	trig = Dust.kr(Demand.kr(Impulse.kr(1),0,Drand(Array.fill(16, {|i| i/2}),inf)));
	// env = EnvGen.kr(Env.xyc([[0, 0, \sin], [0.2, 1, \lin],  [0.7, 0, \lin]]));
	env = EnvGen.kr(Env.adsr(0.01,2,0.8,1,1));
	out = Rongs.ar(trig,trig,Demand.kr(Impulse.kr(50),0,Dser(Array.fill(100, {|i| i/100}),inf))
		// , SawDPW.kr(TRand.kr(0.04,40,trig),0,0.25,0.26),0.5,0.8,0.1,0.5,0.2
	);
	fx = DWGReverb3Band.ar(out,1000,200,fdamp:7);
	// fx = PhasorModal.ar(out,10000,0.5,0.1,1);
		out = Pan2.ar(fx,0,env);
}).add;
)

Ndef(\rong).play;

Ndef(\rong).gui

// Pbind(\scale, Scale.major(Tuning.wcAlpha), \degree, Pseq((0..7) ++ (16..8), inf), \dur, 0.05).play;
// Tuning.directory