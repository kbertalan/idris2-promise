module Examples

import Control.Monad.Either
import Control.Monad.Maybe
import Control.Monad.Reader
import Control.Monad.Trans
import Promise

printSucceded : String -> IO ()
printSucceded = putStrLn . ("Success: " <+>)

printFailed : String -> IO ()
printFailed = putStrLn . ("Failure: " <+>)

main : IO ()
main = do
  let run = runPromise { m = IO } printSucceded printFailed

  run $ MkPromise $ \callbacks => callbacks.onSucceded "Long form of success"

  run $ succeed "Short form of success"

  run $ pure "Monadic success"

  run $ MkPromise $ \callbacks => callbacks.onFailed "Long for of failure"

  run $ fail "Short form of failure"

  run $ do
    first <- pure "Monadic"
    pure "\{first} success"

  run $ do
    first <- pure "Monadic"
    throwError "\{first} failure"

  run $ do
    throwError "Monadic failure" `catchError` (pure . (<+> " handled"))

  run $ do
    throwError "Monadic failure" `catchError` (throwError . (<+> " shadowed"))

  run $ mapFailure (<+> " failure") $ throwError "Monadic"

  run $ do
    let ioString : IO String = pure "Lifted string"
    lift ioString

  run $ resolve "MonadPromise success"

  run $ reject "MonadPromise failure"

  run $ map show
      $ runEitherT { e = Int, m = Promise String IO }
      $ resolve "MonadPromise success" { e = String, n = IO }

  run $ map show
      $ runEitherT { e = Int, m = Promise String IO, a = String }
      $ reject "MonadPromise failure" { e = String, n = IO }

  run $ map show
      $ runEitherT { e = Int, m = Promise String IO, a = String }
      $ throwE $ the Int 1

  run $ map show
      $ runMaybeT { m = Promise String IO }
      $ resolve "Monadic success" { e = String, n = IO }

  run $ map show
      $ runMaybeT { m = Promise String IO, a = String }
      $ reject "Monadic failure" { e = String, n = IO }

  run $ map show
      $ runMaybeT { m = Promise String IO, a = String }
      $ nothing

  run $ runReaderT "success" { m = Promise String IO }
      $ ask >>= pure . ("Monadic " <+>)

