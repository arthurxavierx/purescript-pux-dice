module DND.Dice where

import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Random (RANDOM, randomInt)
import DND.Die (Die(..), dieNumber)
import Data.Maybe (Maybe(..))
import Pux (EffModel, noEffects)
import Pux.Html (Html, (##), button, div, h1, h2, h3, text)
import Pux.Html.Events (onClick)
import Prelude hiding (div)

data Action
  = SelectDie Die
  | Roll
  | Result Int

data DiceState
  = DieSelected Die
  | Rolled { die :: Die, result :: Int }

type State = Maybe DiceState

type Effects eff = (random :: RANDOM | eff)

--

init :: State
init = Nothing

update :: forall eff. Action -> State -> EffModel State Action (Effects eff)
update action state =
  case action, state of
    SelectDie die, _ ->
      noEffects $ Just (DieSelected die)

    Roll, Just s ->
      { state
      , effects: [ do
          result <- liftEff $ roll s
          pure $ Result result
        ]
      }

    Result result, Just (DieSelected die) ->
      noEffects $ Just (Rolled { die, result })

    Result result, Just (Rolled { die }) ->
      noEffects $ Just (Rolled { die, result })

    _, Nothing ->
      noEffects state

  where
    roll = randomInt 1 <<< dieNumber <<< getDie

    getDie (DieSelected die) = die
    getDie (Rolled {die})  = die

view :: State -> Html Action
view state =
  div
    ##
    [ h1 [] [ text "D&D randomizer" ]
    , renderState state
    ]

renderState :: State -> Html Action
renderState state =
  case state of
    Nothing ->
      div
        ##
        [ h2 [] [ text "Please, select a die" ]
        , div
          ## map renderDie dice
        ]

    Just (DieSelected die) ->
      div
        ##
        [ div
          ##
          [ h2 [] [ text "Dice" ]
          , div
            ## map renderDie dice
          ]
        , h3 [] [ text $ "Die: " <> show die ]
        , button [ onClick (const Roll) ] [ text "Roll" ]
        ]

    Just (Rolled {die, result}) ->
      div
        ##
        [ div
          ##
          [ h2 [] [ text "Dice" ]
          , div
            ## map renderDie dice
          ]
        , h3 [] [ text $ "Die: " <> show die ]
        , h3 [] [ text (show result) ]
        , button [ onClick (const Roll) ] [ text "Roll" ]
        ]

  where
    dice = [D4, D6, D8, D10, D20]

    renderDie die =
      button [ onClick (const $ SelectDie die) ] [ text (show die) ]
