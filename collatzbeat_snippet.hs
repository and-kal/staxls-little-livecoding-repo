import Data.List

-- creating a polyrhythm in TidalCycles mini-notation from a Collatz chain/sequence
myNotes = [ x | (a, b) <- zip (replicate 8 1) (replicate 8 0), x <- [a, b]]
collatzChain :: Integral t => t -> [t]
collatzChain 1 = [1]
collatzChain x
    | (x `mod` 2) == 0 = x:collatzChain (x `div` 2)
    | otherwise = x:collatzChain (x*3 + 1)
collatzZip y z = [show (a) ++ "@" ++ show (b) | (a, b) <- zip y z]
-- note that `parseBP_E` is a TidalCycles-specific function
collatzBeat = parseBP_E("{" ++ unwords (collatzZip myNotes (collatzChain 17)) ++ "}%64")