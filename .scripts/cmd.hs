module System.Cmd
module Main where

main :: IO ()
main = do
    rawSystem "ls"
