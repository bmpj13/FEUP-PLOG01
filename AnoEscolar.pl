:-use_module(library(clpfd)).
:-use_module(library(lists)).

% cada disciplina  1 a 4 dias por semana
% cada disciplina tem 2 testes por periodo(meio e fim )-> falta restringir a altura dos testes
% alunos não podem ter mais de 2 testes por semana
% alunos não podem ter testes em dias consecutivos
% alunos não podem ter mais de 2(Afinal é VARIAVEL) tpc por dia
% em pelo menos um dia por semana não pode haver tpc(um dia da semana que deve ser sempre o mesmo )
% em cada disciplina só pode haver tpc em metade das aulas(Afinal é VARIAVEL)
% testes de cada disciplina devem ser o mais proximo possivel em todas as turmas


%lê o ficheiro resolve o problema para cada turma e faz output
%resolveProblem().
%for each class call resolve class and display results

%resolve problema de uma turma
resolveClass(Days,Schedule,Disciplines,Class):-
  fillDisciplines(Days,Disciplines,Class),
  checkHasDiscipline(Class,Schedule),%coloca a 0 a lista de tpc e testes nos dias em que nao existem aulas dessa disciplina
  %domain(NoTpcDay,1,5), % depois por todos os dias a 0 na lista de tpc no dia instanciado
  twoTestsPerPeriod(Class), % garantir 2 testes por periodo, FALTA POLOS NO MEIO/FIM doPERIODO
  testPlacementRestrictions(Days,Class),
  getLabelVars(Class,[],Res),
  write('res'),nl,
  labeling([],Res).



getLabelVars([], Res,Res).

getLabelVars([CurrentDiscipline | NextDiscipline], CurrentList ,Res) :-
  nth1(2,CurrentDiscipline,Test),
  nth1(3,CurrentDiscipline,Tpc),
  append(Test,Tpc,DisciplineVars),
  append(CurrentList,DisciplineVars,Nres),
  getLabelVars(NextDiscipline, Nres, Res).

fillDisciplines(Days,[],[]).

% dias id das disciplinas
fillDisciplines(Days, [Dh | Dt], [H | T]):-
    length(Test,Days),
    domain(Test,0,1),
    length(Tpc,Days),
    domain(Tpc,0,1),
    H = [Dh,Test,Tpc],
    fillDisciplines(Days,Dt,T).


checkHasDiscipline([], _ ).

checkHasDiscipline([[DisciplineId,Test,Tpc] | Tail], Schedule) :-
    checkSchedule(0, DisciplineId, Test, Tpc, Schedule),
    checkHasDiscipline(Tail,Schedule).


checkSchedule(_, _, [], [], _).

checkSchedule(N, DisciplineId, [H1|Test], [H2|Tpc], Schedule) :-
    Index is (N mod 5) + 1,
    nth1(Index, Schedule, L),
    (\+ member(DisciplineId, L),
    H1 #= 0, H2 #= 0, !; true),
    N1 is N+1,
    checkSchedule(N1, DisciplineId, Test, Tpc, Schedule).


twoTestsPerPeriod([]).

twoTestsPerPeriod([CurrentDiscipline | NextDiscipline]) :-
    nth1(2,CurrentDiscipline,Tests),
    sum(Tests,#=,2),
    twoTestsPerPeriod(NextDiscipline).



getNTestsDay([], _ , 0).

getNTestsDay([CurrentDiscipline | NextDiscipline], Id, Value) :- !,
    nth0(1,CurrentDiscipline,Tests),
    nth0(Id,Tests,V),
    Value #= V1 + V,
    getNTestsDay(NextDiscipline, Id, V1).


getAllTestList(_, Days, Days, []).

getAllTestList(Class,N,Days, Result):-
  getNTestsDay(Class, N, Val),
  N1 is N + 1,
  getAllTestList(Class,N1,Days, Val2),
  Result = [Val | Val2].

testPlacementRestrictions(Days,Class) :-
  getAllTestList(Class,0,Days, Tests),%lista com todos os dias e numero de testes de todas as disciplinas da turma nesse dia
  checkWeekTestNumber(Tests,2).


%verifica se o num de testes por semana é menor ou igual a N
checkWeekTestNumber([Tmonday, Ttuesday, Twednesday, Tthursday, Tfriday | Tail], N) :-
    sum([Tmonday, Ttuesday, Twednesday, Tthursday, Tfriday], #=<, N),
    checkWeekTestNumber(Tail,N).

%para quando a ultima semana nao tem 5 dias e condicao de paragem
checkWeekTestNumber(L,N) :-
    sum(L, #=<, N).
