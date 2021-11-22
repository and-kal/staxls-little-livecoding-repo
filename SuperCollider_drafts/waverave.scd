// 2
(
t = FloatArray.fill(512, { |i|
	v = i.linlin(0.0, 512.0, -1.0, 1.0) ;
	v * (i%20).tanh;
}).normalize(-1.0, 1.0);
t.plot ;
b = Buffer.sendCollection(Server.local, t)
)

(
{
	var sig = SinOsc.ar(LFDNoise3.ar(48,30,10000), mul:EnvGen.ar(Env.perc(0.5,releaseTime:10,level:LFNoise0.ar(0.25,0.4,0.25)),Impulse.ar(8))) ;
	Out.ar(0, Pan2.ar(LeakDC.ar(
		BufRd.ar(1,
			bufnum: b,
			phase: sig.linlin(-1.0, 1.0, 0, BufFrames.ir(b)-1))
	)))
}.scope
)

