:- [board].
:- use_module(library(lists)).

tryToMovePiece(BoardState, FX-FY, TX-TY, Board).


validateFromPosition(BoardState, FX-FY).
validateToPosition(BoardState, TX-TY).
validateMovePiece(BoardState, FX-FY, TX-TY, Board).
