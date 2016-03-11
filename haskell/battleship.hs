import Data.Char (ord)
import System.Random

randomShip2 = ["(2,4);(2,5)", "(1,7);(2,7)", "(1,4);(1,5)"]

randomShip3 = ["(5,4);(5,5);(5,6)", "(8,3);(8,4);(8,5)", "(5,2);(5,3);(5,4)"]

randomShip4 = ["(4,8);(5,8);(6,8);(7,8)", "(1,2);(2,2);(3,2);(4,2)", "(6,3);(6,4);(6,5);(6,6)"]

randomShip5 = ["(3,1);(4,1);(5,1);(6,1);(7,1)", "(4,7);(5,7);(6,7);(7,7);(8,7)", "(3,3);(3,4);(3,5);(3,6);(3,7)"]

shootRandom = ["(1,1)", "(1,2)", "(1,3)", "(1,4)", "(1,5)", "(1,6)", "(1,7)", "(1,8)",
               "(2,1)", "(2,2)", "(2,3)", "(2,4)", "(2,5)", "(2,6)", "(2,7)", "(2,8)",
               "(3,1)", "(3,2)", "(3,3)", "(3,4)", "(3,5)", "(3,6)", "(3,7)", "(3,8)",
               "(4,1)", "(4,2)", "(4,3)", "(4,4)", "(4,5)", "(4,6)", "(4,7)", "(4,8)",
               "(5,1)", "(5,2)", "(5,3)", "(5,4)", "(5,5)", "(5,6)", "(5,7)", "(5,8)",
               "(6,1)", "(6,2)", "(6,3)", "(6,4)", "(6,5)", "(6,6)", "(6,7)", "(6,8)",
               "(7,1)", "(7,2)", "(7,3)", "(7,4)", "(7,5)", "(7,6)", "(7,7)", "(7,8)",
               "(8,1)", "(8,2)", "(8,3)", "(8,4)", "(8,5)", "(8,6)", "(8,7)", "(8,8)"]

--The STANDARD names when 1 player option is selected. 
name1 = "player1"
name2 = "computer"

type Field = [[Bool]]
type Coordinate = (Int, Int)
type Ship = [Coordinate]
fieldSize = 8
maxShipSize = 5
minShipSize = 2

checkTurnAI = False

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
splitCoordinatesInString (x:xs) = if x == ';' 
                                      then
                                          [] : splitCoordinatesInString xs
                                      else
                                          (x : head (splitCoordinatesInString xs)) : tail (splitCoordinatesInString xs)

-- Output the field in the terminal
printField :: String -> Field -> [Ship] -> IO ()
printField playerName field ships = do
                                      putStrLn (playerName ++ "'s field status:")
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

-- Remove the ships from the list when they are destroyed
removeDestroyedShips :: [Ship] -> [Ship]
removeDestroyedShips [] = []
removeDestroyedShips (x:xs) | null x    = removeDestroyedShips xs
                            | otherwise = x : removeDestroyedShips xs

-- Check if the ship has been destroyed and remove it from the game when it is
--
-- Input:
--    field:      The field on which the ship is located
--    ship:       The ship that we should check the coordinate against
--    coordinate: The coordinate that is being shot at
--
-- Output:
--    Tuple of the ship that was given as input and a boolean that indicates if the shot was a hit or miss.
--    When the ship is sunk, an empty list will be returned instead of the ship that was given as input.
--
checkShipDestroyed :: Field -> Ship -> Coordinate -> (Ship, Bool)
checkShipDestroyed field ship coordinate = if or [coordinate == coord | coord <- ship] == False 
                                                then do
                                                    (ship, False)    -- Miss
                                                else do
                                                    if and [    select (fst coord) (select (snd coord) field) == True | coord <- ship, coord /= coordinate] == False 
                                                        then
                                                            (ship, True) -- Hit, but not sunk
                                                        else
                                                            ([], True)   -- Hit and sunk

-- Fire a shot at a given coordinate
--
-- Input:
--    enemyField: The 10x10 field of the opponent
--    enemyShips: A list of all the opponent ships
--    coordinate: The position that we are shooting at
--
-- Output:
--    Tuple with the updated enemyField, enemyShips and a boolean to indicate a hit or miss
--
fire :: (Field, [Ship]) -> Coordinate -> (Field, [Ship], Bool)
fire (enemyField, enemyShips) coordinate = (markShot enemyField (snd coordinate) (fst coordinate),
                                            removeDestroyedShips [fst (checkShipDestroyed enemyField ship coordinate) | ship <- enemyShips],
                                            or [snd (checkShipDestroyed enemyField ship coordinate) | ship <- enemyShips])


--Fire with the remaining ships that the player has. 
fireWithEveryShip :: (Field, [Ship]) -> [Ship] -> Field -> [String] -> IO (Field, [Ship])
fireWithEveryShip (enemyField, enemyShips) [] myField nameCheck = return (enemyField, enemyShips)
fireWithEveryShip (enemyField, enemyShips) ourShips myField nameCheck = do
                                                        putStrLn("Enter \"show my ships\" to view BattleField")
                                                        putStrLn ("Enter the coordinates to fire shot (" ++ show (length ourShips) ++ " shots left)")
                                                        string <- getLine
                                                        if (string == "show my ships")
                                                            then if (head nameCheck /= name1 && last nameCheck /= name2) --Check for non-standard names
                                                                then do
                                                                    putStrLn ("Are you " ++ head nameCheck ++ "? (Y/N)") --Find out which player this is
                                                                    answer <- getLine
                                                                    if (answer == "N" || answer == "n")
                                                                        then 
                                                                            printShips enemyField enemyShips
                                                                        else 
                                                                            printShips myField ourShips
                                                                else 
                                                                    printShips myField ourShips --Print only ships for player1, Not the computer. 
                                                            else do 
                                                                putStrLn ("")                                                                
                                                        let coord = convertStringToCoordinates string
                                                        if validateCoordinate coord 
                                                            then do
                                                                let (newEnemyField, newEnemyShips, hit) = fire (enemyField, enemyShips) coord
                                                                if hit 
                                                                    then do
                                                                        putStrLn ("Firing at coordinate (" ++ show (fst coord) ++ "," ++ show (snd coord) ++ "), Hit")
                                                                    else do
                                                                        putStrLn ("Firing at coordinate (" ++ show (fst coord) ++ "," ++ show (snd coord) ++ "), Miss")
                                                                if length newEnemyShips < length enemyShips --Check for destroyed ships. 
                                                                    then do
                                                                        putStrLn "You sunk my battleship!"  
                                                                        fireWithEveryShip (newEnemyField, newEnemyShips) (tail ourShips) myField nameCheck
                                                                    else
                                                                        fireWithEveryShip (newEnemyField, newEnemyShips) (tail ourShips) myField nameCheck
                                                            else
                                                                fireWithEveryShip (enemyField, enemyShips) ourShips myField nameCheck

fireWithEveryShipAI :: (Field, [Ship]) -> [Ship] -> IO (Field, [Ship])
fireWithEveryShipAI (enemyField, enemyShips) [] = return (enemyField, enemyShips)
fireWithEveryShipAI (enemyField, enemyShips) ourShips = do
                                                        putStrLn ("Computer is shooting (" ++ show (length ourShips) ++ " shots left)")
                                                        string <- pick shootRandom
                                                        let coord = convertStringToCoordinates string
                                                        if validateCoordinate coord 
                                                            then do
                                                                let (newEnemyField, newEnemyShips, hit) = fire (enemyField, enemyShips) coord

                                                                if hit 
                                                                    then
                                                                        putStrLn ("Firing at coordinate (" ++ show ((fst coord)) ++ "," ++ show ((snd coord)) ++ "), Hit")
                                                                    else
                                                                        putStrLn ("Firing at coordinate (" ++ show ((fst coord)) ++ "," ++ show ((snd coord)) ++ "), Miss")
                                                                if length newEnemyShips < length enemyShips 
                                                                    then do
                                                                        putStrLn "You sunk my battleship!"
                                                                        fireWithEveryShipAI (newEnemyField, newEnemyShips) (tail ourShips)
                                                                    else
                                                                        fireWithEveryShipAI (newEnemyField, newEnemyShips) (tail ourShips)
                                                            else
                                                                fireWithEveryShipAI (enemyField, enemyShips) ourShips
-- Play the game, one turn at a time
--
-- Input:
--    names:  List of player names
--    fields: List of fields belonging to the players
--    ships:  List of ships belonging to the player
--
-- The first element in the lists, are from the player whose turn it currently is
--
startGame :: [String] -> [Field] -> [[Ship]] -> Bool -> IO ()
startGame names fields ships singlePlayer = do
                            putStrLn ("\n" ++ head names ++ " turn")
                            printField (head names) (head fields) (head ships)
                            printField (last names) (last fields) (last ships)
                            (newField, newShipList) <- fireWithEveryShip (last fields, last ships) (head ships) (head fields) names
                            if length newShipList == 0 
                                then do
                                    putStrLn ("\n" ++ head names ++ " won!\n")
                                    printField (last names) newField newShipList
                                    printField (head names) (head fields) (head ships)
                                else if singlePlayer
                                    then
                                        startAI [last names, head names] [newField, head fields] [newShipList, head ships] 
                                    else
                                        startGame [last names, head names] [newField, head fields] [newShipList, head ships] False

startAI :: [String] -> [Field] -> [[Ship]] -> IO ()
startAI names fields ships = do
                            putStrLn ("\n" ++ head names ++ "'s turn")
                            --printShips (head fields) (head ships)
                            --printField (head names) (head fields) (head ships)
                            --printField (last names) (last fields) (last ships)

                            (newField, newShipList) <- fireWithEveryShipAI (last fields, last ships) (head ships)
                            if length newShipList == 0 
                                then do
                                    putStrLn ("\n" ++ head names ++ "s won!\n")
                                    printField (last names) newField newShipList
                                    printField (head names) (head fields) (head ships)
                                else
                                    startGame [last names, head names] [newField, head fields] [newShipList, head ships] True

-- Input one ship with a given length
inputShip :: [Ship] -> Int -> IO Ship
inputShip placedShips len = do
                                putStrLn ("Enter the coordinates of the ship of length " ++ show len ++ "?")
                                string <- getLine
                                let stringCoords = splitCoordinatesInString string
                                let coords = map convertStringToCoordinates stringCoords
                                if validateShipCoordinates placedShips coords len 
                                    then
                                        return coords
                                    else
                                        inputShip placedShips len

-- Input all the ships for a player
inputShips :: Int -> [Ship] -> IO [Ship]
inputShips shipSize placedShips = if shipSize <= maxShipSize 
                                    then do
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
                                if validateShipCoordinates placedShips coords len 
                                    then
                                        return coords
                                    else
                                        inputShipAI placedShips len

-- Input all the ships for a player
inputShipsAI :: Int -> [Ship] -> IO [Ship]
inputShipsAI shipSize placedShips = if shipSize <= maxShipSize 
                                        then do
                                            ship <- inputShipAI placedShips shipSize
                                            shipList <- inputShipsAI (shipSize + 1) (ship : placedShips)
                                            return (ship : shipList)
                                        else
                                            return []
-- Input the names of the players
inputNames :: IO [String]
inputNames =
            return [name1, name2]
-- The entry point of the program
main :: IO ()
main = do
        putStrLn ("1 or 2 players? Enter a number and press Enter")
        option <- getLine
        if(option == "1" || option == "1 ")
            then do   
                names <- inputNames
                shipsPlayer1 <- inputShips minShipSize []
                shipsPlayer2 <- inputShipsAI minShipSize []
                startGame names [initField, initField] [shipsPlayer1, shipsPlayer2] True --Single Player == True
            else do 
                putStrLn "Enter Name for Player1"
                primPlayer <- getLine
                putStrLn ("Enter Ships for " ++ primPlayer)
                shipsPlayer1 <- inputShips minShipSize [] 

                putStrLn "Enter Name for Player2"
                sconPlayer <- getLine
                putStrLn ("Enter Ships for " ++ sconPlayer)
                shipsPlayer2 <- inputShips minShipSize []
                startGame [primPlayer, sconPlayer] [initField, initField] [shipsPlayer1, shipsPlayer2] False --Single Player == False

