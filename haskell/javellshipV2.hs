import Data.Char (ord)

import System.Random

randomShip2 = ["(2,4);(2,5)"]

randomShip3 = ["(5,4);(5,5);(5,6)"]

randomShip4 = ["(4,8);(5,8);(6,8);(7,8)"]

randomShip5 = ["(3,1);(4,1);(5,1);(6,1);(7,1)"]

type Field = [[Bool]]
type Coordinate = (Int, Int)
type Ship = [Coordinate]
fieldSize = 8
maxShipSize = 5
minShipSize = 2

-- Select the n-th element in a list
select :: Int -> [a] -> a
select n xs = head (drop (n-1) (take n xs))

-- Change n-th element in a list
replace :: Int -> [a] -> a -> [a]
replace n xs x = take (n-1) xs ++ [x] ++ drop n xs

-- Initialize the 8x8 field
initField :: Field
initField = take fieldSize (repeat (take fieldSize (repeat False)))

pick :: [a] -> IO a
pick xs = randomRIO (0, (length xs - 1)) >>= return . (xs !!)

-- Extract the coordinate from the string
-- Also immediately convert the coordinate from range [0,10[ to [1,10]
-- An invalid coordinate is returned when the string isn't of the correct style.
convertStringToCoordinates :: String -> Coordinate
convertStringToCoordinates ['(', x, ',', y, ')'] = ((ord x) - (ord '0'), (ord y) - (ord '0'))
convertStringToCoordinates _ = (-1, -1)

-- Convert the field into a printable string
convertFieldToString :: Field -> [Ship] -> Coordinate -> String
convertFieldToString field ships coordinate
        | fst coordinate <= fieldSize
          && snd coordinate <= fieldSize =  if select (fst coordinate) (select (snd coordinate) field) == True 
                                                then if or [coordinate == coord | ship <- ships, coord <- ship] 
                                                        then 'o' : convertFieldToString field ships (fst coordinate + 1, snd coordinate)
                                                    else 'x' : convertFieldToString field ships (fst coordinate + 1, snd coordinate)
                                           else ' ' : convertFieldToString field ships (fst coordinate + 1, snd coordinate)
                                        
        | snd coordinate <= fieldSize = "H\nH" ++ convertFieldToString field ships (1, snd coordinate + 1)
        | otherwise = []

-- Convert the field into a printable string
printShipsA :: Field -> [Ship] -> Coordinate -> String
printShipsA field ships coordinate
        | fst coordinate <= fieldSize
          && snd coordinate <= fieldSize =  if or [coordinate == coord | ship <- ships, coord <- ship] 
                                            then 'S' : printShipsA field ships (fst coordinate + 1, snd coordinate)
                                            else ' ' : printShipsA field ships (fst coordinate + 1, snd coordinate)
                                        
        | snd coordinate <= fieldSize = "#\n#" ++ printShipsA field ships (1, snd coordinate + 1)
        | otherwise = []

-- Check if a coordinate lies inside the field
validateCoordinate :: Coordinate -> Bool
validateCoordinate coord = and [ fst coord >= 1,
                                 snd coord >= 1,
                                 fst coord <= fieldSize,
                                 snd coord <= fieldSize
                               ]

-- Make sure that the ship is given valid coordinates
validateShipCoordinates :: [Ship] -> Ship -> Int -> Bool
validateShipCoordinates placedShips ship shipLength
    | length ship /= shipLength = False -- Check if ship was given enough coordinates
    | or [coord1 == coord2 | ship2 <- placedShips, coord1 <- ship, coord2 <- ship2] = False -- The coordinates may not overlap with another ship
    | not (and [validateCoordinate coord | coord <- ship]) = False -- Check if coordinates lie in the field
    | and (map (==0) [abs ((fst coord1) - (fst coord2)) | coord1 <- ship, coord2 <- ship]) -- Check if  coordinates are neighbors (vertical)
        = (sum [abs ((snd coord1) - (snd coord2)) | coord1 <- ship, coord2 <- ship]) * 3 == (shipLength-1) * (shipLength^2 + shipLength)
    | and (map (==0) [abs ((snd coord1) - (snd coord2)) | coord1 <- ship, coord2 <- ship]) -- Check if  coordinates are neighbors (horizontal)
        = (sum [abs ((fst coord1) - (fst coord2)) | coord1 <- ship, coord2 <- ship]) * 3 == (shipLength-1) * (shipLength^2 + shipLength)
    | otherwise = False -- Coordinates are not on the same line
        
        
-- Split a string containing coordinates seperated by semi-colons into a list of (unchecked) coordinates.
-- You must still call convertStringToCoordinates on every element in the returned list.
splitCoordinatesInString :: String -> [String]
splitCoordinatesInString [] = [[]]
splitCoordinatesInString (x:xs) = if x == ';' then
                                      [] : splitCoordinatesInString xs
                                  else
                                      (x : head (splitCoordinatesInString xs)) : tail (splitCoordinatesInString xs)

-- Output the field in the terminal
printField :: Field -> [Ship] -> IO ()
printField field ships = do
                          putStrLn (take (fieldSize+2) (repeat 'H') ++ "\nH" ++ convertFieldToString field ships (1, 1) ++ take (fieldSize+1) (repeat 'H') )
                          putStrLn ""

-- Output the field in the terminal
printShips :: Field -> [Ship] -> IO ()
printShips field ships = do
                          putStrLn (take (fieldSize+2) (repeat '#') ++ "\n#" ++ printShipsA field ships (1, 1) ++ take (fieldSize+1) (repeat '#') )
                          putStrLn ""

                    

-- Mark a cell on the field as shot
markShot :: Field -> Int -> Int -> Field
markShot field x y = replace x field (replace y (select x field) True)

play :: [Field] -> [[Ship]] -> IO ()
play fields ships = do
                            putStrLn ("your board:")
                            printShips (head fields) (head ships)
                            putStrLn ("opponent's board:")
                            printShips (last fields) (last ships)


-- Input one ship with a given length
inputShip :: [Ship] -> Int -> IO Ship
inputShip placedShips len = do
                              putStrLn ("Enter the coordinates of the ship of length " ++ show len ++ "?")
                              string <- getLine
                              let stringCoords = splitCoordinatesInString string
                              let coords = map convertStringToCoordinates stringCoords
                              if validateShipCoordinates placedShips coords len then
                                  return coords
                              else
                                  inputShip placedShips len

-- Input all the ships for a player
inputShips :: Int -> [Ship] -> IO [Ship]
inputShips shipSize placedShips = if shipSize <= maxShipSize then
                                      do
                                        ship <- inputShip placedShips shipSize
                                        shipList <- inputShips (shipSize + 1) (ship : placedShips)
                                        return (ship : shipList)
                                  else
                                      return []

-- Input one ship with a given length
chooseShip :: Int -> IO String
chooseShip len = do
                  if len == 2
                    then 
                      do
                        string <- pick randomShip2
                        return string
                  else if len == 3
                    then
                      do
                        string <- pick randomShip3
                        return string
                  else if len == 4
                    then
                      do
                        string <- pick randomShip4
                        return string
                  else if len == 5
                    then
                      do
                        string <- pick randomShip5
                        return string             
                  else
                    return ""
                    

-- Input one ship with a given length
inputShipAI :: [Ship] -> Int -> IO Ship
inputShipAI placedShips len = do
                              string <- chooseShip len
                              let stringCoords = splitCoordinatesInString string
                              let coords = map convertStringToCoordinates stringCoords
                              if validateShipCoordinates placedShips coords len then
                                  return coords
                              else
                                  inputShipAI placedShips len

-- Input all the ships for a player
inputShipsAI :: Int -> [Ship] -> IO [Ship]
inputShipsAI shipSize placedShips = if shipSize <= maxShipSize then
                                      do
                                        ship <- inputShipAI placedShips shipSize
                                        shipList <- inputShipsAI (shipSize + 1) (ship : placedShips)
                                        return (ship : shipList)
                                  else
                                      return []

-- The entry point of the program
main :: IO ()
main = do
         shipsPlayer1 <- inputShips minShipSize []

         shipsPlayer2 <- inputShipsAI minShipSize []

         play [initField, initField] [shipsPlayer1, shipsPlayer2]