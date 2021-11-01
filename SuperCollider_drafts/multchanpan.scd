s.boot
ServerMeter.new(s, 2,6)
Server.local.options.numOutputBusChannels = 6;

s.prepareForRecord(numChannels:6);
s.record;



// 1st instance
(
SynthDef(\panod, {
	arg panfreq = 3, pulmod = 10, ginger = 10, dfmfreq = 10000, reso = 0;
	var osc, freqm, envp, enva, mulch, grr, out, chans;
	enva = EnvGen.kr(Env.adsr(0.2, 0.8, 0.6, 5, peakLevel:0.2), doneAction:2);
	freqm = Pulse.ar(Lag3.kr(pulmod,5),0.25);
	osc = SinOsc.ar(((600*freqm)/2),mul:enva);
	grr = GbmanN.ar(Lag2.kr(ginger,10),0.7,3.2,enva/3);
	envp = LFNoise0.kr(panfreq, 0.5).range(1,-1);
    chans = Array.series(size: 6, start: 0, step: 1);
	out = Out.ar(chans,Limiter.ar(Pan2.ar(DFM1.ar(osc*grr,dfmfreq,Lag.kr(reso,5))),0.8));
};
).add
)

a = Synth(\panod)


a.set(\pulmod, 5, \ginger, 30)
a.set(\pulmod, 12, \ginger, 40)
a.set(\pulmod, 15, \ginger, 100)
a.set(\pulmod, 7.5, \ginger, 30, \panfreq, 1, \reso, 1)
a.set(\pulmod, 6, \ginger, 55, \panfreq, 3, \dfmfreq, 12000, \reso, 0.8)
a.set(\pulmod, 32, \ginger, 70, \panfreq, 4, \dfmfreq, 15000, \reso, 0.9)
a.set(\pulmod, 0.2, \ginger, 80, \panfreq, 12, \dfmfreq, 2000, \reso, 1)

a.free


// 2nd instance
(
SynthDef(\bass, {	arg ofreq = 60, ffreq = 150, tem = 50, chanchang = 1;
	var env, sin, squ, out, busses;
	env = EnvGen.kr(Env.perc(0.1,0.3,0.4),Dust.ar(tem,0.8));
	sin = SinOsc.ar(ofreq,mul:env*1.5);
	squ = CombN.ar(GrainSin.ar(1,sin,0.5,ofreq,mul:env/4),mul:0.4);
//	out = Out.ar(Stepper.kr(Impulse.kr(chanchang,mul:0.5),min:0,max:5), Limiter.ar(Splay.ar([squ,sin]),0.5));
	out = Out.ar(Stepper.kr(Impulse.kr(chanchang,mul:0.5),min:0,max:5), [squ,sin]);
}).add;
)


(
2.do{arg i;
	b = Synth(\bass, [\ffreq, i*2+60])};
)


b.set(\tem, 500);
b.set(\tem, 2000);
b.set(\chanchang, rrand(1,20));

// 3rd instance
(
SynthDef(\clicks, {	arg ofreq = 60, ffreq = 150, tem = 50;
	var env, sin, squ, out, busses;
	env = EnvGen.kr(Env.sine(1,0.2),Dust.ar(tem,0.8));
	sin = CombL.ar(SinOsc.ar(ofreq,mul:env*1.5));
	busses = Saw.kr(5,mul:8,add:1).asInteger;
	out = Out.ar(busses, Limiter.ar(Splay.ar(sin),1));
}).add;
)

c = Synth(\clicks)


// 4rd instance

(
SynthDef(\subsin, {arg amb, sfreq = 120, sphase = 0.2;
	Out.ar([amb],SinOsc.ar([sfreq], [sphase], mul: 0.1))}).add;
)

12.do{arg i; d = Synth(\subsin, [\sfreq, ((i*10)+400), \sphase, (i*0.2-9), \amb, (i%2)])};



s.stopRecording