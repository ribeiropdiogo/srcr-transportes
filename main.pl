%  ___________________________________________
% |                                           |
% |  SRCR - Trabalho Individual       A84442  |
% |                                           |
% |  main.pl                                  |
% |                                           |
% |  Este ficheiro é o principal módulo do    |
% |  sistema. Aqui são invocadosos restantes  |
% |  modulos que compoem o sistema.           |
% |___________________________________________|

% consult('~/Projetos/srcr-transportes/main.pl').

% -------------- Configurações ----------------

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

:- op(900,xfy,'::').

% ----------------- Includes ------------------

% Include do módulo pbase (Predicados Base)
:- include('base.pl').

% Include do módulo de pesquisa não-informada
:- include('ninformada.pl').

% Include do módulo de pesquisa informada
:- include('informada.pl').

% dados do exercicio
:- include('./data/dados.pl').
