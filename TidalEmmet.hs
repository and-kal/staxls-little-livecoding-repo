module Main where

import System.Environment (getArgs)

-- | generate TidalCycles boilerplate
-- | use like this: `runghc .\TidalEmmet.hs .\jam.tidal`

main :: IO ()
main = do
    args <- getArgs
    case args of
        [fileName] -> do
            appendFile fileName "\n"
            appendFile fileName "let \n"
            appendFile fileName "  midiN chan = s \"midi\" # midichan (chan - 1)\n"
            appendFile fileName "in\n"
            appendFile fileName "d1 $\n"
            appendFile fileName "stack [\n\n"
            appendFile fileName "]\n"
            appendFile fileName "#cps(160/60/4)\n\n"
        _ -> putStrLn "Usage: TidalEmmet <filename>"