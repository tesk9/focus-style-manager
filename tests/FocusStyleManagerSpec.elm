module FocusStyleManagerSpec exposing (..)

import Expect
import FocusStyleManager
import Test exposing (..)


styleSpec : Test
styleSpec =
    describe "style"
        [ test "works" <|
            \() ->
                Expect.equal "TODO" FocusStyleManager.style
        ]
