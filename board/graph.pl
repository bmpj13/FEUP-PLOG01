:- use_module(library(ugraphs)).
:- dynamic(edge/1).
:- dynamic(vertex/1).
:- dynamic(graph/1).


initGraph :-
  linkHorizontal(0, 0),
  linkVertical(0, 0),
  findall(X, edge(X), Edges),
  findall(Y, vertex(Y), Vertices),
  vertices_edges_to_ugraph(Vertices, Edges, G),
  assert(graph(G)).


linkHorizontal(_, 28) :-
  true.

linkHorizontal(18, Y) :-
  Vertex1 = [18,Y],
  Vertex2 = [20,Y],
  assert(vertex(Vertex1)),
  assert(vertex(Vertex2)),
  assert(edge(Vertex1-Vertex2)),
  assert(edge(Vertex2-Vertex1)),
  Y2 is Y + 2,
  linkHorizontal(0, Y2).

linkHorizontal(X, Y) :-
  Vertex1 = [X,Y],
  X2 is X + 2,
  Vertex2 = [X2,Y],
  assert(vertex(Vertex1)),
  assert(edge(Vertex1-Vertex2)),
  assert(edge(Vertex2-Vertex1)),
  linkHorizontal(X2, Y).


linkVertical(22, _) :-
  true.


linkVertical(X, 24) :-
  Vertex1 = [X,24],
  Vertex2 = [X,26],
  assert(vertex(Vertex1)),
  assert(vertex(Vertex2)),
  assert(edge(Vertex1-Vertex2)),
  assert(edge(Vertex2-Vertex1)),
  X2 is X + 2,
  linkVertical(X2, 0).


linkVertical(X, Y) :-
  Vertex1 = [X,Y],
  Y2 is Y + 2,
  Vertex2 = [X,Y2],
  assert(vertex(Vertex1)),
  assert(edge(Vertex1-Vertex2)),
  assert(edge(Vertex2-Vertex1)),
  linkVertical(X, Y2).


writeList([]).

writeList([H | T]) :-
  write(H), nl,
  writeList(T).