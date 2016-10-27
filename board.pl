initialBoard([	[0,0,0,0,0,b-20,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,w-20,0,0,0,0,0]]).

printBoard([],Y):-
	printLine(x),
	nl, nl.
printBoard([H|T]):-
	nl,
	printTopCoor(x),
	printLine(x),
	write('1'),
	write(' '),
	printSpaces(H),
	printBoard(T,1).
printBoard([H|T],Y):-
	Y < 9,
	printLine(x),
	Y1 is Y + 1,
	write(Y1),
	write(' '),
	printSpaces(H),
	printBoard(T,Y1).
printBoard([H|T],Y):-
	printLine(x),
	Y1 is Y + 1,
	write(Y1),
	printSpaces(H),
	printBoard(T,Y1).

printTopCoor(X):-
	write('    1   2   3   4   5   6   7   8   9  10  11  12'),
	nl.

printLine(X):-
	write('   -----------------------------------------------'),
	nl.

printSpaces([]):-
	write('|'),
	nl.
printSpaces([H|T]):-
	write('|'),
	translatePrint(H),
	printSpaces(T).

translatePrint(0):-
	write('   ').
translatePrint(Colour-Char):-
	Char < 10,
	write('  '),
	write(Char).
translatePrint(Colour-Char):-
	Char >= 10,
	write(Colour),
	write(Char).
translatePrint(X):-
	write(' '),
	write(X),
	write(' ').
