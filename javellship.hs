--import Data.Array

--main = do 
--	let ship = 1
--	let b = array(1,8) [(x, ship) | x <- [1..8]]
--	let a = array(1,8) [(i, b) | i <- [1..8]]
--ship is a binary value saying either yes there is a ship or no there isnt
--	putStrLn $ show a

 --placeship :: Int a -> Int b -> Int c

data Shot = Shot {
	coordinate :: Int
}

data Square = Square {
	position :: Int,
	ship :: Bool
	firedat :: Bool
	hit :: Bool
}

data Ship = Ship {
	length :: Int
}

data Board = Board {
	size :: Int, 
	squares :: [Square]

}

data Player = Player {
	name :: String
}
placeShip :: Board -> Int -> Board 
placeShip board coord = Board (size board) $
	map (\(Square pos bool) -> Square pos (if pos == coord then True else bool))(squares board)

inputShip :: Player -> Int -> Int-> Board -> Board
inputShip player coord ln board = (if ln /= 0 then inputShip player coord (ln -1) (placeShip board coord) else board)

shoot :: Board -> Shot -> Board
shoot board s = (if checkHit s (squares board) board == True then shotHit shot board else shotMiss shot board)

checkHit :: Shot -> Square -> Board -> Bool 
checkHit s sq = if(ship Square s) == True then shotHit s board True else shotMiss s board False

--save the hit into data structure
shotHit :: Shot -> Board -> Board
shotHit s board = 

--save the miss into data structure
shotMiss :: Shot -> Board -> Board
shotMiss s board = s squares board 