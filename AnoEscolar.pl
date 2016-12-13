:-use_module(library(clpfd)).

% cada disciplina  1 a 4 dias por semana
% cada disciplina tem 2 testes por periodo(meio e fim )
% alunos não podem ter mais de 2 testes por semana
% alunos não podem ter mais de 2 tpc por dia
% em pelo menos um dia por semana não pode haver tpc
% em cada disciplina só pode haver tpc em metade das aulas
% testes de cada disciplina devem ser o mais proximo possivel


%lê o ficheiro resolve o problema para cada turma e faz output
%resolveProblem().
%for each class call resolve class and display results

%resolve problema de uma turma
resolveClass(Days,Schedule,Disciplines,Class):-
  fillDisciplines(Days,Disciplines,Class),
  checkHasDiscipline(Class,Schedule).



fillDisciplines(Days,[],[]).

fillDisciplines(Days, [Dh | Dt], [H | T]):-
    length(Test,Days),
    domain(Test,0,1),
    length(Tpc,Days),
    domain(Tpc,0,1),
    H = [Dh,Test,Tpc],
    fillDisciplines(Days,Dt,T).

checkHasDiscipline([[DisciplineId,Test,Tpc] | Tail], Schedule) :-
    checkSchedule(0, DisciplineId, Test, Tpc, Schedule).


checkSchedule(_, _, [], [], _).

checkSchedule(N, DisciplineId, [H1|Test], [H2|Tpc], Schedule) :-
    Index is (N mod 5) + 1,
    nth1(Index, Schedule, L),
    (\+ member(L, DisciplineId),
    H1 #= 0, H2 #= 0, !; true),
    N1 is N+1,
    checkSchedule(N1, DisciplineId, Test, Tpc, Schedule).
