/*

  Quasigroup completion problem in in ECLiPSe.

  See 
  Carla P. Gomes and David Shmoys:
 "Completing Quasigroups or Latin Squares: Structured Graph Coloring Problem"

  
  See also
  Ivars Peterson "Completing Latin Squares"
  http://www.maa.org/mathland/mathtrek_5_8_00.html
  """
  Using only the numbers 1, 2, 3, and 4, arrange four sets of these 
  numbers into a four-by-four array so that no column or row contains 
  the same two numbers. The result is known as a Latin square.
  ...
  The so-called quasigroup completion problem concerns a table that is 
  correctly but only partially filled in. The question is whether the 
  remaining blanks in the table can be filled in to obtain a complete 
  Latin square (or a proper quasigroup multiplication table).
  """

  Compare with the following models:
  * MiniZinc: http://www.hakank.org/minizinc/quasigroup_completion.mzn
  * Choco   : http://www.hakank.org/choco/QuasigroupCompletion.java
  * JaCoP   : http://www.hakank.org/JaCoP/QuasigroupCompletion.java
  * Gecode/R: http://www.hakank.org/gecode_r/quasigroup_completion.rb
  * Comet   : http://www.hakank.org/comet/quasigroup_completion.co
  * Gecode  : http://www.hakank.org/gecode/quasigroup_completion.cpp


  Model created by Hakan Kjellerstrand, hakank@bonetmail.com
  See also my ECLiPSe page: http://www.hakank.org/eclipse/

*/

:-lib(ic).
:-lib(ic_global).
:-lib(ic_search).

go :-
        solve(1),
        solve(2).

pretty_print(X) :-
        dim(X, [N,N]),
        (for(I, 1, N), param(X, N) do
             (for(J, 1, N), param(X, I) do
                  XX is X[I,J],
                  printf("%2d", XX),
                  write(" ")
             ),
             nl
        ).        


solve(ProblemNum) :-
        problem(ProblemNum, Problem),
        dim(Problem, [N,N]), % get the size of the problem
        Problem[1..N,1..N] :: 1..N,
        (for(I, 1, N), param(Problem, N) do
             ic_global:alldifferent(Problem[I,1..N]),
             ic_global:alldifferent(Problem[1..N,I])
        ),
        search(Problem,0,first_fail,indomain,complete,[backtrack(Backtracks)]),
        nl,
        pretty_print(Problem),
        writeln(backtracks:Backtracks).


%
% Example from Ruben Martins and Inès Lynce
% Breaking Local Symmetries in Quasigroup Completion Problems, page 3
% The solution is unique:
% 1 3 2 5 4
% 2 5 4 1 3
% 4 1 3 2 5
% 5 4 1 3 2
% 3 2 5 4 1
%
% Note: this is an array of arrays
%
problem(1, []([](1, _, _, _, 4),  
              [](_, 5, _, _, _),
              [](4, _, _, 2, _),
              [](_, 4, _, _, _),
              [](_, _, 5, _, 1))).


%
% Example from Gomes & Shmoys, page 3.
% Solution:
% 4 1 2 3
% 2 3 4 1
% 1 4 3 2
% 3 2 1 4
%
problem(2, []([](_, 1, 2, 3),
              [](2, _, 4, 1), 
              [](1, 4, _, 2),
              [](3, _, 1, _))).

% Example from Gomes & Shmoys, page 7
% Two solutions.
%
problem(3, []([](_, 1, _, _),
              [](_, _, 2, _),
              [](_, 3, _, _),
              [](_, _, _, 4))).


%
% Example from Global Constraint Catalogue
% http://www.emn.fr/x-info/sdemasse/gccat/sec2.7.108.html
%
% 12 solutions.
%
problem(4, []([](1, _, _, _),
              [](_, _, _, 3),
              [](3, _, _, _),
              [](_, _, _, 1))).


%
% Problem from http://www.cs.cornell.edu/gomes/QUASIdemo.html
% (n = 10)
% Pattern #1. 
% There are _many_ solutions to this problem.
%
problem(5, []([](_,_,_,1,_,_,_,_,_,_),
              [](_,_,1,_,_,_,_,_,_,_),
              [](_,1,_,_,_,2,_,_,_,_),
              [](1,_,_,_,2,_,_,_,_,_),
              [](_,_,_,2,1,_,_,_,_,_),
              [](_,_,2,_,_,1,_,_,_,_),
              [](_,_,_,_,_,_,1,_,_,_),
              [](_,_,_,_,_,_,_,1,_,2),
              [](_,_,_,_,_,_,_,_,2,_),
              [](_,_,_,_,_,_,_,2,_,_))).


%
% Problem from http://www.cs.cornell.edu/gomes/QUASIdemo.html
% (n = 10)
% Pattern #2. 
% There are _many_ solutions to this problem.
%
problem(6, []([](_,_,1,2,3,4,_,_,_,_),
              [](_,1,2,3,_,_,4,_,_,_),
              [](1,2,3,_,_,_,_,4,_,_),
              [](2,3,_,_,_,_,_,_,4,_),
              [](3,_,_,_,_,_,_,_,_,4),
              [](5,6,_,_,_,_,_,_,_,_),
              [](_,5,6,_,_,_,_,_,_,_),
              [](_,_,5,6,_,_,_,_,_,_),
              [](_,_,_,5,6,_,_,_,_,_),
              [](_,_,_,_,5,6,_,_,_,_))).


%
% Problem from http://www.cs.cornell.edu/gomes/QUASIdemo.html
% (n = 10)
% Pattern #3. 
% Coding:
%    dark red   = 1
%    light blue = 2 
%    dark blue  = 3 
%    light red  = 4
%    brown      = 5
%    green      = 6
%    pink       = 7
%    grey       = 8
%    black      = 9
%    yellow     = 10    
% There are 40944 solutions for this pattern.
%
problem(7, []([](_, _, 1, 5, 2, 6, 7, 8, _, _),
              [](_, 1, 5, 2, _, _, 6, 7, 8, _),
              [](1, 5, 2, _, _, _, _, 6, 7, 8),
              [](5, 2, _, _, _, _, _, _, 6, 7),
              [](2, _, _, _, _, _, _, _, _, 6),
              [](4,10, _, _, _, _, _, _, 3, 9),
              [](_, 4,10, _, _, _, _, 3, 9, _),
              [](_, _, 4,10, _, _, 3, 9, _, _),
              [](_, _, _, 4,10, 3, 9, _, _, _), 
              []( _, _, _, _, 4,9, _, _, _, _))).


%
% Problem from http://www.cs.cornell.edu/gomes/QUASIdemo.html
% (n = 10)
% Pattern #4. 
%  dark red   = 1
%  light blue = 2
%  dark blue  = 3
%  light red  = 4
% Note: There are no solutions to this problem.
%
problem(8, []([](1,_,_,_,_,_,_,_,_,_),
                 [](2,1,_,_,_,_,_,_,_,4),
                 [](3,2,1,_,_,_,_,_,4,_),
                 [](_,3,2,1,_,_,_,4,_,_),
                 [](_,_,3,2,1,_,4,_,_,_),
                 [](_,_,_,3,2,1,_,_,_,_),
                 [](_,_,_,_,3,2,1,_,_,_),
                 [](_,_,_,4,_,3,2,1,_,_),
                 [](_,_,4,_,_,_,3,2,1,_),
                 [](_,4,_,_,_,_,_,3,2,1))).


%
% Problem from http://www.cs.cornell.edu/gomes/QUASIdemo.html
% (n = 10)
% Pattern #5
% Note: There are no solutions to this problem.
%
problem(9, []([](_,_,_,_,_,_,_,_,_,1),
                 [](_,_,_,_,_,_,_,_,1,_),
                 [](_,_,_,_,_,_,_,1,_,_),
                 [](_,_,_,_,_,_,2,_,_,_),
                 [](_,_,_,_,_,1,_,_,_,_),
                 [](_,_,_,_,1,_,_,_,_,_),
                 [](_,_,_,1,_,_,_,_,_,_),
                 [](_,_,1,_,_,_,_,_,_,_),
                 [](_,1,_,_,_,_,_,_,_,_),
                 [](1,_,_,_,_,_,_,_,_,_))).


