:-use_module(library(lists)).

%resolveClass(13,[[1],[2],[2],[1,5],[1,5]],[1,2,5],L).

displayClass([], _):-
  nl,write('---------------------------------------------------------------------------------------------------------').

displayClass([CurrentDiscipline | NextDiscipline], Days):-
  nth1(1,CurrentDiscipline, DisciplineId),
  nth1(2,CurrentDiscipline, Tests),
  nth1(3,CurrentDiscipline, Tpc),
  format('~n------------------------------------------Discipline- ~w ------------------------------------------',[DisciplineId]),
  nl,write('Tests: '),nl,
  displayDayList(Tests,0,Days),
  nl,write('Tpc: '),nl,
  displayDayList(Tpc,0,Days),
  displayClass(NextDiscipline, Days).



displayDayList(_,N,N).

displayDayList(Tests,N,Days) :-
  nth0(N,Tests,V),
  displayNday(N,V),
  N1 is N + 1,
  displayDayList(Tests,N1,Days).

displayNday(N,Val) :-
  Day is (N mod 5),
  write(Val),
  (
    (Day =:= 0, write('-monday | '));
    (Day =:= 1, write('-tuesday | '));
    (Day =:= 2, write('-wednesday | '));
    (Day =:= 3, write('-thursday | '));
    (Day =:= 4, write('-friday '), nl)
  ).