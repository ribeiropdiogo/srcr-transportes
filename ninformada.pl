%  ___________________________________________
% |                                           |
% |  SRCR - Trabalho Individual       A84442  |
% |                                           |
% |  ninformada.pl                            |
% |                                           |
% |  Neste ficheiro estão definidos os        |
% |  predicados relativos à pesquisa não      |
% |  informada.                               |
% |___________________________________________|


% ----------- Pesquisa Depth-First ------------
% Parâmetros: paragem inicial e paragem final
inicial(183).
final(791).

resolvedf(Solucao) :-
          resolvedf(ParagemInicial, [ParagemInicial], Solucao).

resolvedf(Estado, _, []) :- final(Estado),!.

resolvedf(Estado, Historico, [Carreira|Solucao]) :-
					precurso(Estado, Estado1, Carreira),
					nao(membro(Estado1, Historico)),
					resolvedf(Estado1,[Estado1|Historico],Solucao).
