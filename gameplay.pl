:- [board].
:- use_module(library(lists)).

tryToMovePiece(BoardState, FX-FY, TX-TY, Board).


ValidateFromPosition(BoardState, FX-FY).
ValidateToPosition(BoardState, TX-TY).
validateMovePiece(BoardState, FX-FY, TX-TY, Board).
