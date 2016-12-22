:- ensure_loaded('AnoEscolar.pl').

% ------------------------------------------Discipline- 1 ------------------------------------------
% Tests:
% 0-monday | 0-tuesday | 1-wednesday | 0-thursday | 0-friday
% 0-monday | 0-tuesday | 0-wednesday | 0-thursday | 1-friday
% 0-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday

% Tpc:
% 1-monday | 0-tuesday | 1-wednesday | 0-thursday | 1-friday
% 1-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday
% 0-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday

% ------------------------------------------Discipline- 2 ------------------------------------------
% Tests:
% 0-monday | 0-tuesday | 0-wednesday | 0-thursday | 1-friday
% 0-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday
% 0-monday | 1-tuesday | 0-wednesday | 0-thursday | 0-friday

% Tpc:
% 1-monday | 1-tuesday | 0-wednesday | 0-thursday | 1-friday
% 1-monday | 1-tuesday | 0-wednesday | 0-thursday | 1-friday
% 0-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday

% ---------------------------------------------------------------------------------------------------------No Tpc Day: 4

testClass1(Class) :-
    solveClass(15,[[1,2],[2],[1],[2],[1,2]],[1,2], Class).




% ------------------------------------------Discipline- 1 ------------------------------------------
% Tests:
% 0-monday | 0-tuesday | 0-wednesday | 1-thursday | 0-friday
% 0-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday
% 0-monday | 0-tuesday | 0-wednesday | 1-thursday | 0-friday
% 0-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday

% Tpc:
% 1-monday | 1-tuesday | 0-wednesday | 0-thursday | 1-friday
% 1-monday | 1-tuesday | 0-wednesday | 0-thursday | 1-friday
% 1-monday | 1-tuesday | 0-wednesday | 0-thursday | 0-friday
% 0-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday

% ------------------------------------------Discipline- 2 ------------------------------------------
% Tests:
% 0-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday
% 1-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday
% 0-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday
% 1-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday

% Tpc:
% 1-monday | 1-tuesday | 1-wednesday | 0-thursday | 0-friday
% 1-monday | 1-tuesday | 1-wednesday | 0-thursday | 0-friday
% 0-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday
% 0-monday | 0-tuesday | 0-wednesday | 0-thursday | 0-friday

% ---------------------------------------------------------------------------------------------------------No Tpc Day: 4


testClasses2(Class) :-
          run(
            120,
            4,
            1,
            2,
            [
              [[1,2,3],[2,3],[1,2],[3,2],[1]],
              [[1,2],[3,2],[1],[1,2,3],[2,3]],
              [[1,2,3],[2,3],[1,2],[3,2],[1]],
              [[1,2],[3,2],[1],[1,2,3],[2,3]],
              [[1,2,3],[2,3],[1,2],[3,2],[1]],
              [[1,2],[3,2],[1],[1,2,3,4],[2,3]]
            ],
            Class).

testClasses3(Class) :-
          run(
            120,
            2,
            2,
            2,
            [
              [[1,2,3],[2,3,4],[1,2],[3,2],[1,4]],
              [[1,2],[3,2],[1,4],[1,2,3,4],[2,3]],
              [[1,2,3],[2,3],[1,2,4],[3,2,4],[1,4]],
              [[1,2],[3,2],[1,4],[1,2,3],[2,3,4]],
              [[1,2,3],[2,3,4],[1,2],[3,2,4],[1,4]],
              [[1,2,4],[3,2],[1],[1,2,3,4],[2,3]]
            ],
            Class).

testClasses(Class) :-
        run(
          30,
          2,
          2,
          2,
          [
            [[1,2], [2,3], [3,1], [1,2,3], [1]],
            [[1,3], [2,1], [3], [2], [1,2]]
          ],
          Class).
