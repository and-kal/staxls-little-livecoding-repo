s.boot

//test
(
{
    var in, chain;
	in = Out.ar(0, Pan2.ar(SoundIn.ar));
	chain = FFT(Array.fill(2, (LocalBuf(2048))), in);
    IFFT(chain) // inverse FFT
}.play;
)

a = {Out.ar(0, Pan2.ar(In.ar(2),0,2))}.play;

a.free;

//livesignal
(
Ndef(\a,
{
    var in, fft, peakman, freqman;
	in = Pan2.ar(SoundIn.ar(0));
    fft = FFT(LocalBuf(2048, 1), in, wintype:1);
	peakman = SinOsc.kr(0.3,0,20,40);
	freqman = SinOsc.kr(2,0.5,1,10);
	TPV.ar(fft, 2048, 1024, 80, peakman, freqman, 4,2)
}).play
)

//samplesignal
//...


//Gendy-Test

Ndef(\gen, {Pan2.ar(Gendy1.ar(ampdist: 0.2, durdist: 0.1, adparam: 0.3, ddparam: 1, minfreq: SinOsc.kr(2,0,5,45), maxfreq: SinOsc.kr(16,0,15,40), ampscale: 0.5, durscale: 0.5, initCPs: 12, knum: 12, mul: 1.0, add: 0.0))}).play;
