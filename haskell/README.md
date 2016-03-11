# javellship

How to run a simple testFile to analyze the running time of our haskell program: 

How to run the Battleship.hs:
	
	Windows (command prompt):
		$ ghc battleship.hs
		$ battleship.exe
	
	Mac & Linux (terminal)
		$ make
		$ ./Battleship

This explain how to run the executable file with the sample input file called Coordinates.txt

	$ make
	$ ./Battleship < Coordinates.txt

If you want to see the run time of the program then just do (Linux & Mac):
	
	$ time ./Battleship < Coordinates.txt

This will run the Battleship.exe with the input file Coordinates.txt and output the results of the game
plus a report of the real, user, and system time. 
