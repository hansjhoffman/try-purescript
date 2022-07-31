module Main where

import Prelude
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.VDom.Driver (runUI)

data Action
  = Increment
  | Decrement

type State
  = Int

type Input
  = Unit

initialState :: Input -> State
initialState _ = 0

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div [ HP.class_ $ HH.ClassName "flex flex-col items-center justify-center mt-[25vh]" ]
    [ HH.button
        [ HP.class_ $ HH.ClassName "flex h-12 w-12 rounded items-center justify-center bg-indigo-500 text-white font-semibold text-lg"
        , HP.attr (HH.AttrName "data-test-id") "btn-decrement"
        , HE.onClick \_ -> Decrement
        ]
        [ HH.text "-" ]
    , HH.div [ HP.class_ $ HH.ClassName "flex my-6 font-semibold text-lg" ]
        [ HH.text $ show state
        ]
    , HH.button
        [ HP.class_ $ HH.ClassName "flex h-12 w-12 rounded items-center justify-center bg-indigo-500 text-white font-semibold text-lg"
        , HP.attr (HH.AttrName "data-test-id") "btn-increment"
        , HE.onClick \_ -> Increment
        ]
        [ HH.text "+" ]
    ]

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  Increment -> H.modify_ \state -> state + 1
  Decrement -> H.modify_ \state -> state - 1

component :: forall q o m. H.Component q Input o m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    runUI component unit body
