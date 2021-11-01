~csv = SemiColonFileReader.read("C:/Users/Li/Desktop/SuperCollider/sessions/SC_csvread/machine-learning-databases00000dataset.csv",true).postcs



//trying to scale -1 to 1 floats to slices of audible range
//~csvsc = Array.fill (200, {LinLin.kr(~csv, -1.0, 1.0, 50, 400)});
//~csvsc = ~csv.linlin(-1.0, 1.0, 50, 400);

//taken from The Sonification Handbook 10.4.1
/*(
~csv.do({
~scaling = {|j| j.linlin(-1.0, 1.0, 50, 400)};
~scaledarray = Array.fill(10, {~csv.do{|array| \scaling.value(array)}});
})
)
*/


//massive 3-op FM synth
(
SynthDef(\muzz, {|freq1, freq2, freq3, dur = 0.6, dropfac = 2| var env, out, sig, osc1, osc2, osc3;
	env = EnvGen.kr(Env.sine(dur,0.75),doneAction:2);
	osc1 = SinOsc.ar(LinLin.ar(freq1,-2,2,25,1000),rrand(0,1),env);
		osc2 = PulseDPW.ar(LinLin.ar(freq2,-2,2, 25, 14000),rrand(0.01,1),env/2);
//supernoisy		osc3 = SawDPW.ar(LinLin.ar(freq3,-2,2, 50, 1800),rrand(0,1),env/5);
	osc3 = Blip.ar(LinLin.ar(freq3,-2,2, 50, 180),LFNoise0.ar(20,200,1000),env/2);
	sig = (osc1*(osc1**3))+(osc2*(osc3*(osc3/0.75)));
	//add some fx
	sig = WaveLoss.ar(sig,dropfac,100,1);
	out = Out.ar(0, Pan2.ar(sig, LFNoise1.ar(8,0.8)));
}).add;
)

//test
m = Synth(\muzz, [\freq1, 200, \freq2, 300, \freq3, 30]);

//now with the array
(
Pdef(\bringit, (Pbind(
	\instrument, \muzz,
	\dur, Prand(Array.rand(12, (1/3),(4/1)),inf),
	//all freqs times 10, b/c the array's mostly in the 0.0x range
	\freq1, (Prand(Array.fill(50, ({|k| k = rrand(0,~csv.size); ~csv[k]})).flatten,inf).asInteger)*10,
	\freq2, (Prand(Array.fill(50, ({|k| k = rrand(0,~csv.size); ~csv[k]})).flatten,inf).asInteger)*10,
    \freq3, (Prand(Array.fill(50, ({|k| k = rrand(0,~csv.size); ~csv[k]})).flatten,inf).asInteger)*10,
	\dropfac, Prand(Array.rand(100,2,90),inf);
)).play(TempoClock(100/60)));
)