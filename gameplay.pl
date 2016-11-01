:- use_module(library(lists)).

%finds piece in line
findPiece(0, 0, Piece, Enum).
findPiece([Piece|T], FX, Piece, Enum):-
	Enum = FX,
	findPiece(0, 0, H, Enum).
findPiece([H|T], FX, Piece, Enum):-
	Enum < FX,
	EnumNew is Enum + 1,
	findPiece(T, FX, Piece, EnumNew).

replacePiece(TX, [], Piece, HNew, Enum, Final):-
	reverse(HNew, Final).
replacePiece(TX, Board, Piece, _, -1, Final):-
	replacePiece(TX, Board, Piece, [], 0, Final).
replacePiece(TX, [H|T], Piece, HNew, Enum, Final):-
	TX = Enum,
	append([Piece], HNew, FinalH),
	Enum2 is Enum + 1,
	replacePiece(TX, T, Piece, FinalH, Enum2, Final).
replacePiece(TX, [H|T], Piece, HNew, Enum, Final):-
	TX \== Enum,
	append([H], HNew, FinalH),
	Enum2 is Enum + 1,
	replacePiece(TX, T, Piece, FinalH, Enum2, Final).

%finds line where piece is 
findLine(0,0,Line,Enum).
findLine([Line|T], FX-FY, Line, Enum):-
	Enum = FY,
	findLine(0,0,H,Enum).
findLine([H|T], FX-FY, Line, Enum):-
	Enum < FY,
	EnumNew is Enum + 1,
	findLine(T, FX-FY, Line, EnumNew).

%check if piece belongs to player
checkIfBelongsToPlayer(Player, C-N):-
	Player = C.
checkIfBelongsToPlayer(Player, C):-
	Player = C.
%Check if doesnt belong to player
checkIfDoesntBelongToPlayer(Player, C-N):-
	Player \== C.
checkIfDoesntBelongToPlayer(Player, C):-
	Player \== C.

%checks every single cell for different move types
%horizontal
horizontalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FXNew = TX, FYNew = TY,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line, FXNew, Piece, 0),
	checkIfDoesntBelongToPlayer(Player, Piece).
%left
horizontalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FXNew > TX, FYNew = TY,
	FXNew1 is FXNew - 1,
	findLine(BoardState, FXNew1-FYNew, Line, 0),
	findPiece(Line, FXNew1, Piece, 0),
	Piece = 0,
	horizontalMovement(Player, BoardState, FX-FY, TX-TY, FXNew1-FYNew).
%right
horizontalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FXNew < TX, FYNew = TY,
	FXNew1 is FXNew + 1,
	findLine(BoardState, FXNew1-FYNew, Line, 0),
	findPiece(Line, FXNew1, Piece, 0),
	Piece = 0,
	horizontalMovement(Player, BoardState, FX-FY, TX-TY, FXNew1-FYNew).
%vertical
verticalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew = TY, FXNew = TX,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line,FXNew, Piece, 0),
	checkIfDoesntBelongToPlayer(Player, Piece).
%up
verticalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew > TY, FXNew = TX,
	FYNew1 is FYNew - 1,
	findLine(BoardState, FXNew-FYNew1, Line, 0),
	findPiece(Line,FXNew, Piece, 0),
	Piece = 0,
	verticalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew1).
%down
verticalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew < TY, FXNew = TX,
	FYNew1 is FYNew + 1 ,
	findLine(BoardState, FXNew-FYNew1, Line, 0),
	findPiece(Line,FXNew, Piece, 0),
	Piece = 0,
	verticalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew1).
%diagonal
diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew = TY,	FXNew = TX,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line,FXNew, Piece, 0),
	checkIfDoesntBelongToPlayer(Player, Piece).
%top left
diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew > TY,	FXNew > TX,
	FYNew1 is FYNew - 1,
	FXNew1 is FXNew - 1,
	findLine(BoardState, FXNew1-FYNew1, Line, 0),
	findPiece(Line,FXNew1, Piece, 0),
	Piece = 0,
	diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew1-FYNew1).
%top right
diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew > TY,	FXNew < TX,
	FYNew1 is FYNew - 1,
	FXNew1 is FXNew + 1,
	findLine(BoardState, FXNew1-FYNew1, Line, 0),
	findPiece(Line,FXNew1, Piece, 0),
	Piece = 0,
	diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew1-FYNew1).
%bottom right 
diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew < TY,	FXNew < TX,
	FYNew1 is FYNew + 1,
	FXNew1 is FXNew + 1,
	findLine(BoardState, FXNew1-FYNew1, Line, 0),
	findPiece(Line,FXNew1, Piece, 0),
	Piece = 0,
	diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew1-FYNew1).
%bottom left
diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew < TY,	FXNew > TX,
	FYNew1 is FYNew + 1,
	FXNew1 is FXNew - 1,
	findLine(BoardState, FXNew1-FYNew1, Line, 0),
	findPiece(Line,FXNew1, Piece, 0),
	Piece = 0,
	diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew1-FYNew1).

%If player eats a queen he wins.
checkEndGame(b, Piece, Victory):-
	Victory is 0.
checkEndGame(w, Piece, Victory):-
	Victory is 0.
checkEndGame(0, [Colour-Number], Victory):-
	Number >= 2,
	Victory is 0.
	%TODO drop piece
checkEndGame([Colour-Char], Piece, Victory):-
	Victory is 1.
checkEndGame(Char, Piece, Victory):-
	Char = 0, 
	Victory is 0.

%Replaces TX-TY
eatPiece(Player, Piece, [], FX-FY, TX-TY, Board, It, Victory, FinalBoard):-
	append([], Board, FinalBoard).
eatPiece(Player, Piece, [H|T], FX-FY, TX-TY, Board, It, Victory, FinalBoard):-
	It = TY,
	findPiece(H, TX, PieceInCell, 0),
	checkEndGame(PieceInCell, Piece, Victory),
	replacePiece(TX, H, Piece, HNew, -1, Final),
	append(Board, [Final], NewBoard),
	It2 is It + 1,
	eatPiece(Player, Piece, T, FX-FY, TX-TY, NewBoard, It2, Victory, FinalBoard).
eatPiece(Player, Piece, [H|T], FX-FY, TX-TY, Board, It, Victory, FinalBoard):-
	It \== TY,
	append(Board, [H], NewBoard),
	It2 is It + 1,
	eatPiece(Player, Piece, T, FX-FY, TX-TY, NewBoard, It2, Victory, FinalBoard).

%Cleans FX-TX
eatPieceInitialPosition(Piece, [], FX-FY, Board, It, FinalBoard):-
	append([], Board, FinalBoard).
eatPieceInitialPosition([Colour-Char], [H|T], FX-FY, Board, It, FinalBoard):-
	It = FY,
	replacePiece(FX, H, Char, HNew, -1, Final),
	append(Board, [Final], NewBoard),
	It2 is It + 1,
	eatPieceInitialPosition(Piece, T, FX-FY, NewBoard, It2, FinalBoard).
eatPieceInitialPosition(Piece, [H|T], FX-FY, Board, It, FinalBoard):-
	It = FY,
	replacePiece(FX, H, 0, HNew, -1, Final),
	append(Board, [Final], NewBoard),
	It2 is It + 1,
	eatPieceInitialPosition(Piece, T, FX-FY, NewBoard, It2, FinalBoard).
eatPieceInitialPosition(Piece, [H|T], FX-FY, Board, It, FinalBoard):-
	It \== TY,
	append(Board, [H], NewBoard),
	It2 is It + 1,
	eatPieceInitialPosition(Piece, T, FX-FY, NewBoard, It2, FinalBoard).

%main function to move piece (by calling all other functions) - IF Victory=1 -> End game
tryToMovePiece(Player, BoardState, FX-FY, TX-TY, FinalBoard2, Victory):-
	validateFromPosition(Player, BoardState, FX-FY),
	validateToPosition(Player, BoardState, FX-FY, TX-TY),
	write('validation TO ok'), nl,
	findLine(BoardState, FX-FY, Line, 0),
	findPiece(Line, FX, Piece, 0),
	eatPiece(Player, Piece, BoardState, FX-FY, TX-TY, TempBoard, 0, Victory, FinalBoard),
	eatPieceInitialPosition(Piece, FinalBoard, FX-FY, TempBoard, 0, FinalBoard2).

%validates if the position input is inside the board and belongs to the player
validateFromPosition(Player, BoardState, FX-FY):-
	findLine(BoardState, FX-FY, Line, 0),
	findPiece(Line, FX, Piece, 0),
	checkIfBelongsToPlayer(Player, Piece).

%Validates if movement is valid in terms of direction, then moves piece
validateToPosition(Player, BoardState, FX-FY, TX-TY):-
	FX = TX,
	%Vertical
	TY =< 11,
	TY >= 0,
	verticalMovement(Player, BoardState, FX-FY, TX-TY, FX-FY).
validateToPosition(Player, BoardState, FX-FY, TX-TY):-
	FY = TY,
	%Horizontal
	TX =< 11,
	TX >= 0,
	horizontalMovement(Player, BoardState, FX-FY, TX-TY, FX-FY).
validateToPosition(Player, BoardState, FX-FY, TX-TY):-
	%Diagonal
	DeslocX is abs(FX - TX),
	DeslocY is abs(FY - TY),
	DeslocY = DeslocX,
	diagonalMovement(Player, BoardState, FX-FX, TX-TY, FX-FY).
