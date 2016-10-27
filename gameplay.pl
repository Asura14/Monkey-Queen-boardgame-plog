:- [board].
:- use_module(library(lists)).

%finds piece in line
findPiece([H|T], FX, Piece, Enum):-
	Enum = FX,
	Piece is H.
findPiece([H|T], FX, Piece, Enum):-
	Enum < FX,
	EnumNew is Enum +1,
	findPiece(T, FX, Piece, EnumNew).

%finds line where piece is
findLine([H|T], FX-FY, Line, Enum):-
	Enum = FY,
	Line is H
	findPiece(H, FX, Line, 0).
findLine([H|T], FX-FY, Line, Enum):-
	Enum < FY,
	EnumNew is Enum + 1,
	findLine(T, FX-FY, Line, EnumNew).

%todo: Clean FX-TX and replace TX-TY
eatPiece(Player, BoardState, FX-FY, TX-TY, Board).

%check if piece belongs to player
checkIfBelongsToPlayer(Player, X).
checkIfBelongsToPlayer(Player, C-N):-
	Player = C.
checkIfBelongsToPlayer(Player, C):-
	Player = C.

horizontalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew):-
	FXNew = TX,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line, FXNew, Piece, 0),
	not(checkIfBelongsToPlayer(Player, Piece)),
	eatPiece(Player, BoardState, FX-FY, TX-TY, Board).
horizontalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew):-
	FXNew > TX + 1,
	FXNew is FX - 1,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line, FXNew, Piece, 0),
	Piece = 0,
	horizontalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew).

	
%main function to move piece
tryToMovePiece(Player, BoardState, FX-FY, TX-TY, Board):-
	validateFromPosition(Player, BoardState, FX-FY, TX-TY),
	validateToPosition(Player, BoardState, FX-FY, TX-TY, Board).

%validates if the position input is inside the board and belongs to the player
validateFromPosition(Player, BoardState, FX-FY):-
	findLine(BoardState, FX-FY, Line, 0),
	findPiece(Line, FX, Piece, 0),
	checkIfBelongsToPlayer(Player, Piece).

%Validates if movement is valid in terms of direction
validateToPosition(Player, BoardState, FX-FY, TX-TY, Board):-
	FX = TX,
	%Vertical
	TY =< 11,
	TY => 0.
validateToPosition(Player, BoardState, FX-FY, TX-TY, Board):-
	FY = TY,
	%Horizontal
	TX =< 11,
	TX => 0,
	horizontalMovement(Player, BoardState, FX-FY, TX-TY, Board, FX-FY).

validateToPosition(Player, BoardState, FX-FY, TX-TY, Board):-
	%Diagonal
	DeslocX is FX - TX,
	DeslocY is FY - TY,
	abs(DeslocY) = abs(DeslocX).

