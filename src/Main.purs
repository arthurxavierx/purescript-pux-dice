module Main where

import Prelude
import Control.Monad.Eff (Eff)
import DND.Dice (Action, State, Effects, init, update, view)
import Pux (App, Config, CoreEffects, renderToDOM, start)
import Pux.Devtool (Action, start) as Pux.Devtool

initialState :: State
initialState = init

config :: forall eff. State -> Config State Action (Effects eff)
config state =
  { initialState: state
  , update
  , view
  , inputs: []
  }

main :: forall eff. State -> Eff (CoreEffects (Effects eff)) (App State Action)
main state = do
  app <- start (config state)
  renderToDOM "#app" app.html
  pure app

debug :: forall eff. State -> Eff (CoreEffects (Effects eff)) (App State (Pux.Devtool.Action Action))
debug state = do
  app <- Pux.Devtool.start (config state)
  renderToDOM "#app" app.html
  pure app
