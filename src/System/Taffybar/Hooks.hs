module System.Taffybar.Hooks
  ( module System.Taffybar.DBus
  , module System.Taffybar.Hooks
  ) where

import Control.Concurrent
import Control.Monad.Trans
import System.Taffybar.Context
import System.Taffybar.DBus
import System.Taffybar.Information.Network

newtype NetworkInfoChan = NetworkInfoChan (Chan [(String, (Rational, Rational))])

buildInfoChan :: Double -> IO NetworkInfoChan
buildInfoChan interval = do
  chan <- newChan
  _ <- forkIO $ monitorNetworkInterfaces interval $ writeChan chan
  return $ NetworkInfoChan chan

getNetworkChan :: TaffyIO NetworkInfoChan
getNetworkChan = getStateDefault $ lift $ buildInfoChan 2.0
