module Main

import Test.Golden

examples : TestPool
examples = MkTestPool "Examples" [] Nothing [ "examples" ]

main : IO ()
main = runner [ examples ]
