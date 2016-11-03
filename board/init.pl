:- dynamic(board/1).
:- dynamic(position/3).

board([[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], [orange,1], [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], [orange,2], [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], [yellow, 1], [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], [yellow, 2], [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square] ]).



position([orange, 1], 6, 6).
position([orange, 2], 14, 6).
position([yellow, 1], 6, 20).
position([yellow, 2], 14, 20).
