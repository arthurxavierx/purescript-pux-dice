module DND.Die where

import Prelude

data Die = D4 | D6 | D8 | D10 | D20

instance showDie :: Show Die where
  show D4 = "D4"
  show D6 = "D6"
  show D8 = "D8"
  show D10 = "D10"
  show D20 = "D20"

dieNumber :: Die -> Int
dieNumber D4 = 4
dieNumber D6 = 6
dieNumber D8 = 8
dieNumber D10 = 10
dieNumber D20 = 20
