//taken from CMSC.7.10.5, p. 140

//~t = TempoClock.new(1);

(
Ndef(\cumpiu,
{
var chime, freqSpecs, burst, totalHarm = 20;
var burstEnv, att = 0, burstLength = 0.001;

freqSpecs = `[
 {rrand(5, 15)*8}.dup(totalHarm), //freq array
 {rrand(0.1, 0.4)}.dup(totalHarm).normalizeSum.round(0.01), //amp array
 {rrand(2, 1)}.dup(totalHarm)]; //decay rate array

burstEnv = Env.perc(0.001, burstLength,level:0.8); //envelope times
burst = BrownNoise.ar(EnvGen.kr(burstEnv, gate: LFDNoise3.kr(4))); //Noise burst

		Pan2.ar(Resonz.ar(Klank.ar(freqSpecs, burst)*MouseX.kr(0.05, 0.1),130,1.5))
}).fadeTime_(2).play;
)



(
Ndef(\cumpiuuu,
{
var chime, freqSpecs, burst, totalHarm = 20;
var burstEnv, att = 0, burstLength = 0.005;

freqSpecs = `[
 {exprand(100.0, 10000.0)}.dup(totalHarm), //freq array
 {rrand(0.1, 0.33)}.dup(totalHarm).normalizeSum.round(0.01), //amp array
 {rrand(0.5, 0.25)}.dup(totalHarm)]; //decay rate array

burstEnv = Env.perc(0, burstLength); //envelope times
		burst = PinkNoise.ar(EnvGen.kr(burstEnv, gate: Impulse.kr(8))); //Noise burst

	Pan2.ar(Klank.ar(freqSpecs, burst)*MouseX.kr(0.1, 0.33))
}).fadeTime_(2).play;
)


(
Ndef(\ringmodklank,
{
var carr, mod, chime, freqSpecs1, freqSpecs2, burst;
var burstEnv, att = 0, burstLength = 0.0125;

freqSpecs1 = `[
			Array.geom(20,1000,0.75), //freq array
			Array.geom(20,0.05, 0.9).normalizeSum.round(0.01), //amp array
			Array.geom(20,1,0.75)]; //decay rate array

freqSpecs2 = `[
			Array.geom(20,50,1.1), //freq array
			Array.geom(20,0.5, 0.9).normalizeSum.round(0.01), //amp array
			Array.geom(20,1,0.75)]; //decay rate array

burstEnv = Env.perc(0.001, burstLength,level:1/5); //envelope times
burst = BrownNoise.ar(EnvGen.kr(burstEnv, gate: Impulse.kr(8))); //Noise burst
carr = Klank.ar(freqSpecs1, burst);
mod = Klank.ar(freqSpecs2, burst);
Pan2.ar(
			DiodeRingMod.ar(carr, mod)
		)
}).fadeTime_(0.5).play;
)