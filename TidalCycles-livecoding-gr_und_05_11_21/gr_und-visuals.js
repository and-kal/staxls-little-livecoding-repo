// couple of patches for visuals in ojack's hydra
// https://hydra.ojack.xyz/


a.show()

osc(2)
  .modulateHue(osc(.002))
  .colorama( ({time}) => Math.sin(time) * .05)
  .diff(voronoi(() => time*30)
    .modulate(osc(-2,2)))
  .invert()
  .shift(.3,.16,.4)
  .luma(0.85)
  .add(shape(.2,.2) //
    .modulateRepeat(osc(.2,2), .3) //
    .modulateScale(osc(1,1),1) //
  )
  .out(o0);


//////////////

osc(.2,() => a.fft[0]*0.01,() => a.fft[1]*1).colorama(0.4,0.4,0.4)
.modulateRepeat(
src(o0).thresh(0.6)
.invert()
.scale(.015)
.diff(src(o0).modulateScale(shape(() => a.fft[2] + 4)), 0.3)
)
.out(o0);

src(o0).saturate(4).out(o0)

//////////////

osc(.5,2)
.mult(voronoi(10)
.modulateScale(osc(
  () => a.fft[1]*.01)
    )
.modulate(
  osc(.8,.9,.7)
).colorama(
  () => a.fft[0]*.6,
  () => a.fft[1]*.6,
  () => a.fft[2]*.6)
)
.modulateScale(voronoi(() =>  a.fft[2]*15 + 100).colorama(.12,.2,.92).invert()
)
.out()

//////////////

shape(20)
.invert()
.scale(0.5)
.modulateRotate(src(o0))
.modulateScale(voronoi(() => a.fft[1]*40))
.modulateScale(osc(2,.6,.9))
.colorama(
  () => a.fft[0]/2.5,
  () => a.fft[1]/2.5,
  () => a.fft[2]/2.5
)
// .diff(src(o0))
.out(o0)
