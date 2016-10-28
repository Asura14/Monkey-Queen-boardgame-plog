:- use_module(library(lists)).

%finds piece in line
findPiece([], FX, Piece, Enum):-
	fail.
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
	Line is H,
	findPiece(H, FX, Line, 0).
findLine([H|T], FX-FY, Line, Enum):-
	Enum < FY,
	EnumNew is Enum + 1,
	findLine(T, FX-FY, Line, EnumNew).

%check if piece belongs to player
checkIfBelongsToPlayer(Player, X).
checkIfBelongsToPlayer(Player, C-N):-
	Player = C.
checkIfBelongsToPlayer(Player, C):-
	Player = C.

%checks every single cell for different move types
horizontalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew):-
	FXNew = TX,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line, FXNew, Piece, 0),
	not(checkIfBelongsToPlayer(Player, Piece)).
horizontalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew):-
	FXNew > TX,
	FXNew1 is FX - 1,
	findLine(BoardState, FXNew1-FYNew, Line, 0),
	findPiece(Line, FXNew1, Piece, 0),
	Piece = 0,
	horizontalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew1-FYNew).
horizontalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew):-
	FXNew < TX,
	FXNew1 is FX + 1,
	findLine(BoardState, FXNew1-FYNew, Line, 0),
	findPiece(Line, FXNew1, Piece, 0),
	Piece = 0,
	horizontalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew1-FYNew).
verticalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew):-
	FYNew = TY,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line,FXNew-FYNew, TX-TY, Board),
	not(checkIfBelongsToPlayer(Player, Piece)).
verticalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew):-
	FYNew > TY,
	FYNew1 is FYNew + 1 ,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line,FXNew-FYNew, TX-TY, Board),
	Piece = 0,
	verticalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew1-FYNew).
verticalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew):-
	FYNew < TY,
	FYNew1 is FYNew - 1 ,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line,FXNew-FYNew, TX-TY, Board),
	Piece = 0,
	verticalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew1-FYNew).
diagonalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew):-
	FYNew = TY,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line,FXNew-FYNew, TX-TY, Board),
	not(checkIfBelongsToPlayer(Player, Piece)).
diagonalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew):-
	FYNew > TY,
	FXNew > FX,
	FYNew1 is FYNew + 1,
	FXNew1 is FXNew + 1,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line,FXNew-FYNew, TX-TY, Board),
	Piece = 0,
	diagonalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew1-FYNew).
diagonalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew):-
	FYNew > TY,
	FXNew < FX,
	FYNew1 is FYNew + 1,
	FXNew1 is FXNew - 1,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line,FXNew-FYNew, TX-TY, Board),
	Piece = 0,
	diagonalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew1-FYNew).
diagonalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew):-
	FYNew < TY,
	FXNew < FX,
	FYNew1 is FYNew - 1,
	FXNew1 is FXNew - 1,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line,FXNew-FYNew, TX-TY, Board),
	Piece = 0,
	diagonalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew1-FYNew).
diagonalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew-FYNew):-
	FYNew < TY,
	FXNew > FX,
	FYNew1 is FYNew - 1,
	FXNew1 is FXNew + 1,
	findLine(BoardState, FXNew-FYNew, Line, 0),
	findPiece(Line,FXNew-FYNew, TX-TY, Board),
	Piece = 0,
	diagonalMovement(Player, BoardState, FX-FY, TX-TY, Board, FXNew1-FYNew).

%If player eats a queen he wins.
checkEndGame(Char, Victory):-
	Char = b.
checkEndGame(Char, Victory):-
	Char = w.
checkEndGame(Char, Victory):-
	Char = 0.
checkEndGame([Colour-Char], Victory):-
	Victory is 1.

%todo: Clean FX-TX and replace TX-TY
eatPiece(Player, Piece, [], FX-FY, TX-TY, Board, It, Victory).
eatPiece(Player, Piece, [H|T], FX-FY, TX-TY, Board, It, Victory):-
	It = FY,
	nth0(FX, H, PieceInCell),
	checkEndGame(PieceInCell, Victory),
	nth0(FX, H, Piece, HNew),
	append(Board, [HNew]),
	It2 is It + 1,
	eatPiece(Player, [H|T], FX-FY, TX-TY, Board, It2, Victory).
eatPiece(Player, Piece, [H|T], FX-FY, TX-TY, Board, It, Victory):-
	append(Board, [H]),
	It2 is It + 1,
	eatPiece(Player, [H|T], FX-FY, TX-TY, Board, It2, Victory).

%main function to move piece (by calling all other functions) - IF Victory=1 -> End game
tryToMovePiece(Player, BoardState, FX-FY, TX-TY, Board, Victory):-
	validateFromPosition(Player, BoardState, FX-FY, TX-TY),
	validateToPosition(Player, BoardState, FX-FY, TX-TY, Board),
	findLine(BoardState, FX-FY, Line, 0),
	findPiece(Line, FX, Piece, 0),
	eatPiece(Player, Piece, BoardState, FX-FY, TX-TY, Board, 0, 0).

%validates if the position input is inside the board and belongs to the player
validateFromPosition(Player, BoardState, FX-FY):-
	findLine(BoardState, FX-FY, Line, 0),
	findPiece(Line, FX, Piece, 0),
	checkIfBelongsToPlayer(Player, Piece).

%Validates if movement is valid in terms of direction, then moves piece
validateToPosition(Player, BoardState, FX-FY, TX-TY, Board):-
	FX = TX,
	%Vertical
	TY =< 11,
	TY >= 0,
	verticalMovement(Player, BoardState, FX-FY, TX-TY, Board, FX-FY).
validateToPosition(Player, BoardState, FX-FY, TX-TY, Board):-
	FY = TY,
	%Horizontal
	TX =< 11,
	TX >= 0,
	horizontalMovement(Player, BoardState, FX-FY, TX-TY, Board, FX-FY).
validateToPosition(Player, BoardState, FX-FY, TX-TY, Board):-
	%Diagonal
	DeslocX is FX - TX,
	DeslocY is FY - TY,
	abs(DeslocY) = abs(DeslocX).

