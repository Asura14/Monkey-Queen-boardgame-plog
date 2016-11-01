:- [gameplay].
:- use_module(library(lists)).

initialBoard(Board):- append([],[
				[0,0,0,0,0,b-20,0,0,0,0,0,0],
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
				[0,0,0,0,0,0,w-20,0,0,0,0,0]], Board).

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

nextPlayer(ivory, cigar).
nextPlayer(cigar, ivory).
getPlayer(ivory, w).
getPlayer(cigar, b).

gameControler(Board, Player, 1, 1):-
	nl,
	printBoard(Board),
	write('CONGRATULATIONS '), write(Player), write('! You won this game!'), nl, nl.
gameControler(Board, Player, 0, 1):-
	nl, printBoard(Board), nl,
	write('Player with '), write(Player), write(' pieces turn.'), nl,
	write('Move Piece Line (number.): '), read(Y1), skip_line,
    write('Move Piece Column (number.): '), read(X1), skip_line,
	write('To Line (number.): '), read(Y2), skip_line,
    write('To Column (number.): '), read(X2), skip_line,
    getPlayer(Player, PlayerChar),
    FX is X1 - 1,
    FY is Y1 - 1,
    TX is X2 - 1,
    TY is Y2 - 1,
    tryToMovePiece(PlayerChar, Board, FX-FY, TX-TY, NextBoard, Victory),
    nextPlayer(Player, NextPlayer),
    gameControler(NextBoard, NextPlayer, Victory, 1).

mainMenu(Option):-
	repeat,
	write('1) 1 vs 1'),nl,
	write('2) 1 vs PC'),nl,
	write('3) PC vs PC'),nl,
	write('0) Exit'),nl,nl,
	write('Option: '),
	read(Option), skip_line.

game(Board):-
	mainMenu(Option),
	Option>=0, Option < 4,
	initialBoard(Board),
	gameControler(Board, ivory, 0, Option).
