s.boot

// built upon https://medium.com/@hinea/diy-granular-synthesis-in-supercollider-e2f5d3d6b23a

~sample = Buffer.read(s, "C:/Users/Li/Documents/samples breaks/skits_spokenword/skit_iloveyoulucifer.wav");

(
  SynthDef(\playSample, {
    var outBus = 0;
    var susLevel = 0.6;
    var releaseTime = LFNoise0.kr(100, 1, 0.2);
    var startPos = LFNoise2.kr(5, 1, 0.0) * ~sample.numFrames;
    var gate = Line.kr(1, 0, 0.005);
    var amp = Linen.kr(gate, 0.01, susLevel, releaseTime, 2);
	var playBuf = PlayBuf.ar(2, ~sample, Rand(-1,1), 1, startPos: startPos, doneAction: 2);
    Out.ar(outBus, playBuf * amp);
    }).add
  )

(
d = Pxrand(
  [10, 20, 30, 50, 80, 90, 120, 140, 150, 180, 200]/200, inf).asStream;
t = Task({
 loop({
  x = Synth(\playSample);
    d.value.wait;
 });
});
t.start;
)

// grain samples played in randomly ordering sequence

~sample2 = Buffer.read(s, "C:/Users/Li/Documents/samples_new/ladysnowblood1.wav");

(
  SynthDef(\playSample2, {|startpos, grain = 0.0005, imp = 10|
    var outBus = 0;
	var amp = EnvGen.ar(Env([0.2],[grain]),doneAction:2);
	var playBuf = PlayBuf.ar(2, ~sample2, 2, Impulse.ar(imp), startPos: startpos * ~sample2.numFrames, loop:0, doneAction: 2);
    Out.ar(outBus, playBuf * amp);
    }).add
  )

(
Pbind(\instrument, \playSample2,
	\startpos, Prand(Array.rand(100,0.0,0.2),inf),
	\imp, Pseq([2,5,10,Rest(1)]/0.005,inf);
).play;
)