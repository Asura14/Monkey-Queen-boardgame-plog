:- prolog_flag(single_var_warnings,_,off).
:- [gameplay].
:- use_module(library(lists)).
:- use_module(library(random)).

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
printBoard([H|T], Y):-
	Y < 9,
	printLine(x),
	Y1 is Y + 1,
	write(Y1),
	write(' '),
	printSpaces(H),
	printBoard(T,Y1).
printBoard([H|T], Y):-
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

nextPlayer(white, black).
nextPlayer(black, white).
getPlayer(white, w).
getPlayer(black, b).

gameController(_,_,_,0).
%Game End
gameController(Board, Player, 1, _):-
	nl,
	printBoard(Board),
	nextPlayer(Player, NextPlayer),
	write('CONGRATULATIONS '), write(NextPlayer), write('! You won this game!'), nl, nl.
%Player turn
gameController(Board, Player, 0, 1):-
	nl, printBoard(Board), nl,
	playerMove(Board, Player, Victory, NextBoard),
    nextPlayer(Player, NextPlayer),
    gameController(NextBoard, NextPlayer, Victory, 1).
%Computer turn
gameController(Board, white, 0, 2):-
	nl, printBoard(Board), nl,
	playerMove(Board, white, Victory, NextBoard),
	nl, printBoard(NextBoard), nl,	
	write('PCs turn...'), nl,
	pcMove(NextBoard, black, Victory2, NextBoard2),
    gameController(NextBoard2, white, Victory2, 2).

%Calls gameplay functions to try and execute player's desired move
playerMove(Board, Player, Victory, NextBoard):-
	repeat, nl,
	write('Player with '), write(Player), write(' pieces turn.'), nl,
	write('Piece To Move Line (number.): '), read(Y1), skip_line,
    write('Piece To Move Column (number.): '), read(X1), skip_line,
	write('To Line (number.): '), read(Y2), skip_line,
    write('To Column (number.): '), read(X2), skip_line,
    getPlayer(Player, PlayerChar),
    FX is X1 - 1,
    FY is Y1 - 1,
    TX is X2 - 1,
    TY is Y2 - 1,
    tryToMovePiece(PlayerChar, Board, FX-FY, TX-TY, NextBoard, Victory).

%Calls gameplay functions to try and execute pc random move
pcMove(Board, Player, Victory, NextBoard):-
	repeat,
    random(FX, 0, 11),
    random(FY, 0, 11),
    random(TX, 0, 11),
    random(TY, 0, 11),
    getPlayer(Player, PlayerChar),
    tryToMovePiece(PlayerChar, Board, FX-FY, TX-TY, NextBoard, Victory).

mainMenu(Option):-
	repeat,
	write('Select any of the options bellow: '), nl,
	write('1) 1 vs 1'),nl,
	write('2) 1 vs PC'),nl,
	write('0) Exit'),nl,nl,
	write('Option: '),
	read(Option), skip_line.

game(Board):-
	nl, nl, write(' Welcome to Monkey Queen'), nl, nl,
	mainMenu(Option),
	Option>=0, Option < 4,
	initialBoard(Board),
	gameController(Board, white, 0, Option).