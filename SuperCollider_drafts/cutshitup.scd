// (
// var sf, file;
// TempoClock.default.tempo_(2.3);
// Routine.run({sf= BBCutBuffer("C:/Users/Li/Desktop/Call Nasty - Покатайся со мной/inthemovies/loop - killing cars.wav",8);
// 	s.sync; // this forces a wait for the Buffer to load
// 	(BBCut2(CutBuf1(sf),BBCutProc11.new(8,2,5,stutterspeed:8))).play; // will use TempoClock.default so depends what tempo that is at
// });
// )


(
var sf, file;
TempoClock.default.tempo_(2);
	Routine.run({sf= BBCutBuffer("C:/Users/Li/Desktop/06 - Chop Suey!.wav",32);
	s.sync; // this forces a wait for the Buffer to load
	(BBCut2(CutBuf1(sf),BBCutProc11.new(16,0.8,12,stutterspeed:2))).play; // will use TempoClock.default so depends what tempo that is at
	});
)