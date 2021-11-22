var sig, harmonics = 50 ;
//var phases = Array.fill(harmonics, {0});
var phases = Array.fill(harmonics, {2pi.rand});
var amplitudes = Array.fill(harmonics, {1}) ;
sig = Signal.sineFill(1024, amplitudes, phases) ;
sig.play ;

sc.server.boot

s.quitAll

s.boot

// (
// SynthDef(\bla, {var freq, sign, out;
// 	freq = Pulse.kr(3);
// 	sign = if ((freq), {sign = SinOsc.ar(LFNoise2.ar(20),0,LFNoise2.ar(500,2),1)},{
// 	sign = SinOsc.ar(LFNoise2.ar(10),0,LFNoise2.ar(50,2),1)});
// out = Out.ar([0,1], sign)}).add;
// )
//
// x = Synth(\bla);


(
SynthDef(\bla2, {var freq, sign, out, sinvar;
	sinvar = LFNoise1.ar(2,1.5,1.51);
	freq = SinOsc.kr(sinvar,0,200,500);
	sign = Select.ar(freq > 500, [SinOsc.ar(LFNoise2.ar(3),0,LFNoise2.ar(500,0.8)),
		SinOsc.ar(LFNoise2.ar(10),0,LFNoise2.ar(5000,0.8))]);
	out = Out.ar([0,1], sign)}).add;
)


x = Synth(\bla2);


Synth.dumpAllMethods
x.clear
x.stop

// {SinOsc.ar(200,0,Pulse.ar(50,rrand(0.1,0.9),1.2).clip2(0.2))}.play;