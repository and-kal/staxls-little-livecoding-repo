:set -fno-warn-orphans -Wno-type-defaults -XMultiParamTypeClasses -XOverloadedStrings
:set prompt ""

-- Import all the boot functions and aliases.
import Sound.Tidal.Boot

default (Rational, Integer, Double, Pattern String)

-- Create a Tidal Stream with the default settings.
-- To customize these settings, use 'mkTidalWith' instead
tidalInst <- mkTidal

-- tidalInst <- mkTidalWith [(superdirtTarget { oLatency = 0.01 }, [superdirtShape])] (defaultConfig {cFrameTimespan = 1/50, cProcessAhead = 1/20})

-- This orphan instance makes the boot aliases work!
-- It has to go after you define 'tidalInst'.
instance Tidally where tidal = tidalInst

-- `enableLink` and `disableLink` can be used to toggle synchronisation using the Link protocol.
-- Uncomment the next line to enable Link on startup.
enableLink 

-- You can also add your own aliases in this file. For example:
-- fastsquizzed pat = fast 2 $ pat # squiz 1.5

-- variables for built-in 6-op `superfm`
:{
let fmamp op = pF ("amp" ++ show op)
    fmratio op = pF ("ratio" ++ show op)
    fmdt op = pF ("detune" ++ show op)
    fmmod opa opb = pF ("mod" ++ show opa ++ show opb)
    fmegrate op step = pF ("egrate" ++ show op ++ show step)
    fmeglevel op step = pF ("eglevel" ++ show op ++ show step)
    fmfb = pF "feedback"
    lfof = pF "lfofreq"
    lfod = pF "lfodepth" --amplitude 0 - 1
    fmparam function = foldr (#) (gain 1) . zipWith function [1..]
    fma = fmparam fmamp
    fmr = fmparam fmratio
    fmd = fmparam fmdt
    fmer op = fmparam (fmegrate op) -- higher nr = faster
    fmel op = fmparam (fmeglevel op)
    fmm opa = fmparam (fmmod opa)
:}

midiN chan = s "midi" # midichan (chan - 1) -- ^ make MIDI channels 1-indexed

:set prompt "tidal> "
:set prompt-cont ""
