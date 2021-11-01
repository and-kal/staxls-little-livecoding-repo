s.boot;

MIDIClient.init;

m = MIDIOut.newByName("loopMIDI Port", "loopMIDI Port");

(
SynthDef(\imnobody, {
	Out.ar(m
}

(
	Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\chan, 0,
	\midiout, m,
	\midinote, Pseq([60], inf),
//			\dur, Pseq(Array.fill(200, {|i| ((i.exp)/100).linexp(0.5, 2,0.1, (i)/50)}))
			\dur, Pshuf([[Array.rand(100,0.1,0.2)].trunc(0.01) ++ [Rest(1)!10]].flat)
		).play;
	)


	Array.fill(200, {|i| ((i.exp)/100).linexp(0.5, 2,0.1, (i)/50)})

		(Array.rand(100,0.1,0.5)).trunc(0.01)

	[].fl