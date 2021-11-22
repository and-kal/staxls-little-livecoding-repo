// Wave Terrain stuff by dkmayer https://scsynth.org/t/wave-terrain-synthesis/3424
(
s.boot;
s.scope;
s.freqscope;
)

// function for wave terrain example

f = { |x, y| sin(x) - (sin(y) * log2(x * (x*10+1))/(10))};
// g = { |x, y| (sin(x) + sin(x * y) * ln((x / 20) + 20)) / 2 };

// check the surface produced by the function with GeoGebra

// copy and paste this syntax into GeoGebra Input, it needs ln for the natural logarithm
// (sin(x) - (sin(y) * ln(x * x + 1))) / 10


// circular path through the terrain, mouse control for distance from origin

(
x = {
	var r = MouseX.kr(0, 25);
	// stereo expansion
	var phi = LFSaw.ar([50, 50.1], -1).range(0, 2pi);
	var x = r * cos(phi);
	var y = r * sin(phi);
	Limiter.ar(f.(x, y), 0.2)
}.play
)

// my comment:
//tweaking it massively; maybe not good for yr speakers
(
x = {
	//var r = MouseX.kr(0, 550);
	var r = 100;
	// stereo expansion
	var phi = LFSaw.ar([200, 250], -1).range(0.1, 2pi-0.1);
	var x = r * cos(phi);
	var y = r * sin(phi);
	Limiter.ar(LeakDC.ar(
		HPF.ar(f.(x, y), 400*(Dust.kr(120,60)),0.25),
		0.9
	), 0.8,0.05)
}.play
)

x.release(3)


(
{Pan2.ar(
	FreqShift.ar(
		LFDNoise3.ar,FSinOsc.kr(9.25,0,5000,100).unipolar,0,10.85*Impulse.kr(8)
	)
)
}.play;
)
