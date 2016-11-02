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

%Replaces Element at TX from [H|T] to Piece
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

%checks every single cell for different move types, cells have to be 0s
%horizontal
%left
horizontalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FXNew > TX + 1, FYNew = TY,
	FXNew1 is FXNew - 1,
	findLine(BoardState, FXNew1-FYNew, Line, 0),
	findPiece(Line, FXNew1, Piece, 0),
	Piece = 0,
	horizontalMovement(Player, BoardState, FX-FY, TX-TY, FXNew1-FYNew).
%right
horizontalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FXNew < TX - 1, FYNew = TY,
	FXNew1 is FXNew + 1,
	findLine(BoardState, FXNew1-FYNew, Line, 0),
	findPiece(Line, FXNew1, Piece, 0),
	Piece = 0,
	horizontalMovement(Player, BoardState, FX-FY, TX-TY, FXNew1-FYNew).
horizontalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew).
%vertical
%up
verticalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew > TY + 1, FXNew = TX,
	FYNew1 is FYNew - 1,
	findLine(BoardState, FXNew-FYNew1, Line, 0),
	findPiece(Line,FXNew, Piece, 0),
	Piece = 0,
	verticalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew1).
%down
verticalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew < TY - 1, FXNew = TX,
	FYNew1 is FYNew + 1 ,
	findLine(BoardState, FXNew-FYNew1, Line, 0),
	findPiece(Line,FXNew, Piece, 0),
	Piece = 0,
	verticalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew1).
verticalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew).
%diagonal
%top left
diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew > TY + 1,	FXNew > TX,
	FYNew1 is FYNew - 1,
	FXNew1 is FXNew - 1,
	findLine(BoardState, FXNew1-FYNew1, Line, 0),
	findPiece(Line,FXNew1, Piece, 0),
	Piece = 0,
	diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew1-FYNew1).
%top right
diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew > TY + 1,	FXNew < TX,
	FYNew1 is FYNew - 1,
	FXNew1 is FXNew + 1,
	findLine(BoardState, FXNew1-FYNew1, Line, 0),
	findPiece(Line,FXNew1, Piece, 0),
	Piece = 0,
	diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew1-FYNew1).
%bottom right 
diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew < TY - 1,	FXNew < TX,
	FYNew1 is FYNew + 1,
	FXNew1 is FXNew + 1,
	findLine(BoardState, FXNew1-FYNew1, Line, 0),
	findPiece(Line,FXNew1, Piece, 0),
	Piece = 0,
	diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew1-FYNew1).
%bottom left
diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew):-
	FYNew < TY - 1,	FXNew > TX + 1,
	FYNew1 is FYNew + 1,
	FXNew1 is FXNew - 1,
	findLine(BoardState, FXNew1-FYNew1, Line, 0),
	findPiece(Line,FXNew1, Piece, 0),
	Piece = 0,
	diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew1-FYNew1).
diagonalMovement(Player, BoardState, FX-FY, TX-TY, FXNew-FYNew).

%If player eats a queen he wins.
checkEndGame(b, Piece, Victory,DropPiece, NewPiece):-
	Victory is 0,
	DropPiece is 0,
	append([],[Piece],NewPiece).
checkEndGame(w, Piece, Victory,DropPiece, NewPiece):-
	Victory is 0,
	DropPiece is 0,
	append([],[Piece],NewPiece).
checkEndGame(0, Colour-Number, Victory, DropPiece, NewPiece):-
	Number > 2,
	Victory is 0,
	%drop piece
	Number2 is Number - 1,
	append([],[Colour-Number2],NewPiece),
	DropPiece is 1.
checkEndGame(Colour-Char, Piece, Victory,DropPiece, NewPiece):-
	Victory is 1,
	DropPiece is 0,
	append([],[Piece],NewPiece).
checkEndGame(Char, Piece, Victory,DropPiece, NewPiece):-	
	Char = 0,
	Victory is 0,
	DropPiece is 0,
	append([],[Piece],NewPiece).

%Replaces TX-TY
eatPiece(Player, Piece, [], FX-FY, TX-TY, Board, It, Victory, FinalBoard, DropPiece):-
	append([], Board, FinalBoard).
eatPiece(Player, Piece, [H|T], FX-FY, TX-TY, Board, It, Victory, FinalBoard, DropPiece):-
	It = TY,
	findPiece(H, TX, PieceInCell, 0),	
	checkEndGame(PieceInCell, Piece, Victory, DropPiece, [NewPiece|Empty]),
	replacePiece(TX, H, NewPiece, HNew, -1, Final),
	append(Board, [Final], NewBoard),
	It2 is It + 1,
	eatPiece(Player, Piece, T, FX-FY, TX-TY, NewBoard, It2, Victory, FinalBoard, DropPiece).
eatPiece(Player, Piece, [H|T], FX-FY, TX-TY, Board, It, Victory, FinalBoard, DropPiece):-
	It \== TY,
	append(Board, [H], NewBoard),
	It2 is It + 1,
	eatPiece(Player, Piece, T, FX-FY, TX-TY, NewBoard, It2, Victory, FinalBoard, DropPiece).

%Cleans FX-FX
replacePieceAtPosition(Piece, [], FX-FY, Board, It, FinalBoard):-
	append([], Board, FinalBoard).
replacePieceAtPosition(Colour-Char, [H|T], FX-FY, Board, It, FinalBoard):-
	It = FY,
	replacePiece(FX, Colour-Char, Char, HNew, -1, Final),
	append(Board, [Final], NewBoard),
	It2 is It + 1,
	replacePieceAtPosition(Piece, T, FX-FY, NewBoard, It2, FinalBoard).
replacePieceAtPosition(Piece, [H|T], FX-FY, Board, It, FinalBoard):-
	It = FY,
	replacePiece(FX, H, Piece, HNew, -1, Final),
	append(Board, [Final], NewBoard),
	It2 is It + 1,
	replacePieceAtPosition(Piece, T, FX-FY, NewBoard, It2, FinalBoard).
replacePieceAtPosition(Piece, [H|T], FX-FY, Board, It, FinalBoard):-
	It \== FY,
	append(Board, [H], NewBoard),
	It2 is It + 1,
	replacePieceAtPosition(Piece, T, FX-FY, NewBoard, It2, FinalBoard).

%leaves a child behind if queen is size>2 and if doesn't eat an enemy piece
dropChild(0, Colour, FX-FY, Board, BoardWithChild):-
	write('entrou'),
	append(Board, [], BoardWithChild),
	write('done').
dropChild(1, Colour-Number, FX-FY, Board, BoardWithChild):-
	replacePieceAtPosition(Colour, Board, FX-FY, TempBoard, 0, BoardWithChild).

%main function to move piece (by calling all other functions) - IF Victory=1 -> End game
tryToMovePiece(Player, BoardState, FX-FY, TX-TY, BoardWithChild, Victory):-
	validateFromPosition(Player, BoardState, FX-FY),
	validateToPosition(Player, BoardState, FX-FY, TX-TY),
	findLine(BoardState, FX-FY, Line, 0),
	findPiece(Line, FX, Piece, 0),
	checkIfBelongsToPlayer(Player, Piece),
	write('about to eat piece'), nl,
	eatPiece(Player, Piece, BoardState, FX-FY, TX-TY, TempBoard, 0, Victory, FinalBoard, DropPiece),
	write('ate piece'), nl,
	replacePieceAtPosition(0, FinalBoard, FX-FY, TempBoard, 0, FinalBoard2),
	write(DropPiece), nl,
	dropChild(DropPiece, Piece, FX-FY, FinalBoard2, BoardWithChild).

%validates if the position input is inside the board and belongs to the player
validateFromPosition(Player, BoardState, FX-FY):-
	findLine(BoardState, FX-FY, Line, 0),
	findPiece(Line, FX, Piece, 0),
	checkIfBelongsToPlayer(Player, Piece).

%Validates if movement is valid in terms of direction,
validateToPosition(Player, BoardState, FX-FY, TX-TY):-
	FX = TX,
	%Vertical
	TY =< 11, TY >= 0,
	verticalMovement(Player, BoardState, FX-FY, TX-TY, FX-FY).
validateToPosition(Player, BoardState, FX-FY, TX-TY):-
	FY = TY,
	%Horizontal
	TX =< 11, TX >= 0,
	horizontalMovement(Player, BoardState, FX-FY, TX-TY, FX-FY).
validateToPosition(Player, BoardState, FX-FY, TX-TY):-
	%Diagonal
	DeslocX is abs(FX - TX),
	DeslocY is abs(FY - TY),
	DeslocY = DeslocX,
	TX =< 11, TX >= 0,
	TY =< 11, TY >= 0,
	diagonalMovement(Player, BoardState, FX-FX, TX-TY, FX-FY).
