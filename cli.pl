getWallCoords(X, Y, O) :-
		write('Wall coords'),nl,
		write('Enter X coord: '),
		read(X),
		write('Enter Y coord: '),
		read(Y),
		write('Enter Orientation (h/v)'),
		read(O).


getPawnCoords(X, Y) :-
		write('Pawn coords'),nl,
		write('Enter X coord: '),
		read(X),
		write('Enter Y coord: '),
		read(Y).
