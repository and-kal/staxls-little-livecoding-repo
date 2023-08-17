import Data.List

myNotes = ["0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"]
collatzChain 1 = [1]
collatzChain x
    | (x `mod` 2) == 0 = x:collatzChain (x `div` 2)
    | otherwise = x:collatzChain (x*3 + 1)
collatzZip _  [] = ""
collatzZip [] _ = ""
collatzZip (y:ys) (z:zs) = (y ++ "@" ++ show (z) ++ " " ++ (collatzZip ys zs))
-- collatzBeat startVal = "{" ++ (collatzZip myNotes (collatzChain startVal)) ++ "}%16"
collatzBeat startVal = parsePB_E("{" ++ (collatzZip startVal myNotes) ++ "}%16")

main = print (collatzBeat 15)
