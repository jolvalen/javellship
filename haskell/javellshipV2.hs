import Data.Char (ord)

type Field = [[Bool]]
type Coordinate = (Int, Int)
type Ship = [Coordinate]
fieldSize = 8
maxShipSize = 5
minShipSize = 2

-- Select the n-th element in a list
select :: Int -> [a] -> a
select n xs = head (drop (n-1) (take n xs))

-- Initialize the 8x8 field
initField :: Field
initField = take fieldSize (repeat (take fieldSize (repeat False)))

-- Extract the coordinate from the string
-- Also immediately convert the coordinate from range [0,10[ to [1,10]
-- An invalid coordinate is returned when the string isn't of the correct style.
convertStringToCoordinates :: String -> Coordinate
convertStringToCoordinates ['(', x, ',', y, ')'] = ((ord x) - (ord '0') + 1, (ord y) - (ord '0') + 1)
convertStringToCoordinates _ = (-1, -1)

-- Convert the field into a printable string
convertFieldToString :: Field -> [Ship] -> Coordinate -> String
convertFieldToString field ships coordinate
        | fst coordinate <= fieldSize
          && snd coordinate <= fieldSize = if select (fst coordinate) (select (snd coordinate) field) == True then
                                               if or [coordinate == coord | ship <- ships, coord <- ship] then 'o' : convertFieldToString field ships (fst coordinate + 1, snd coordinate)
                                                   else 'x' : convertFieldToString field ships (fst coordinate + 1, snd coordinate)
                                           else ' ' : convertFieldToString field ships (fst coordinate + 1, snd coordinate)
                                        
        | snd coordinate <= fieldSize = "H\nH" ++ convertFieldToString field ships (1, snd coordinate + 1)
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

printField :: Field -> [Ship] -> IO ()
printField field ships = do
                                      putStrLn (take (fieldSize+2) (repeat 'H') ++ "\nH" ++ convertFieldToString field ships (1, 1) ++ take (fieldSize+1) (repeat 'H') )
                                      putStrLn ""


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
-- The entry point of the program
main :: IO ()
main = do
         shipsPlayer1 <- inputShips minShipSize []
         printField initField shipsPlayer1