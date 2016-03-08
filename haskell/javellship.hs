type Field = [[Bool]]
fieldSize = 8

-- Initialize the 8x8 field
initField :: Field
initField = take fieldSize (repeat (take fieldSize (repeat False)))

-- Output the field in the terminal
printField :: Field -> IO ()
printField [] = return()
printField field = do
                     putStrLn (show(head field))
                     printField (tail field)


-- Input the names of the players
inputNames :: IO [String]
inputNames = do
               putStrLn "First player, please input your name:"
               name1 <- getLine
               putStrLn "Second player, please input your name:"
               name2 <- getLine
               return [name1, name2]

-- The entry point of the program
main :: IO ()
main = do
         
         printField initField