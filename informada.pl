%  ___________________________________________
% |                                           |
% |  SRCR - Trabalho Individual       A84442  |
% |                                           |
% |  informada.pl                             |
% |                                           |
% |  Neste ficheiro estão definidos os        |
% |  predicados relativos à pesquisa          |
% |  informada.                               |
% |___________________________________________|

% -------------- Pesquisa RBFS ----------------

pesquisarbfs(NodoInicial,NodoFinal) :-
        evolucao(destino(NodoFinal)),
        rbfs([],[(NodoInicial, 0/0/0)],99999,_,yes,S),
        involucao(destino(NodoFinal)),
        reverse(S,Solucao),
        duracao(Solucao,D),
        escreve_resultado(Solucao,D).

rbfs(Caminho,[(Nodo, G/F/FF)|Nodos],Limite,FF,no,_) :-
        FF > Limite, !.

rbfs(Caminho,[(Nodo, G/F/FF)|_],_,_,yes,[Nodo|Caminho]) :-
        F = FF,
        destino(Nodo).

rbfs(_,[],_,_,never,_) :- !.

rbfs(Caminho,[(Nodo,G/F/FF)|Nodos],Limite,NovoFF,S,Solucao) :-
        FF =< Limite,
        findall(Filho/Custo, (percurso(Nodo,Filho,Carreira,Custo),
        \+ member(Filho,Caminho)),Filhos),
        herda(F,FF,FFHerdado),
        succlist(G,FFHerdado,Filhos,NodosSuc),
        bestff(Nodos,ProxMelhorFF),
        min(Limite,ProxMelhorFF,NLimite),!,
        rbfs([Nodo|Caminho],NodosSuc,NLimite,NovoFF2,S2,Solucao),
        continua(Caminho,[(Nodo, G/F/NovoFF2)|Nodos],Limite,NovoFF,S2,S,Solucao).

continua(Caminho,[N|Ns],Limite,NovoFF,never,S,Solucao) :- !,
        rbfs(Caminho,Ns,Limite,NovoFF,S,Solucao).

continua(_,_,_,_,yes,yes,Solucao).

continua(Caminho,[N|Ns],Limite,NovoFF,no,S,Solucao) :-
        insert(N,Ns,NovoNs), !,
        rbfs(Caminho,NovoNs,Limite,NovoFF,S,Solucao).

succlist(_,_,[],[]).

succlist(G0,FFHerdado,[Nodo/C|NCs],Nodos) :-
        G is G0 + C,
        estimativa(Nodo,H),
        F is G + H,
        max(F,FFHerdado,FF),
        succlist(G0,FFHerdado,NCs,Nodos2),
        insert((Nodo,G/F/FF),Nodos2,Nodos).

herda(F,FF,FF) :- FF > F,!.
herda(F,FF,0).

insert((N,G/F/FF),Nodos,[(N,G/F/FF)|Nodos]) :-
      bestff(Nodos,FF2),
      FF =< FF2, !.

insert(N,[N1|Ns],[N1|Ns1]) :-
      insert(N,Ns,Ns1).

bestff([(N,F/G/FF)|Ns],FF).
bestff([],99999).

% ------------ Pesquisa A-Estrela -------------

pesquisaae(NodoInicial,NodoFinal) :-
        evolucao(destino(NodoFinal)),
        resolve_aestrela(NodoInicial,S,C),
        involucao(destino(NodoFinal)),
        write(S), nl, write(C).

resolve_aestrela(Nodo,Caminho,Custo) :-
	estimativa(Nodo, Estima),
	aestrela([[Nodo]/0/Estima], InvCaminho/Custo/_),
	inverso(InvCaminho, Caminho).

aestrela(Caminhos, Caminho) :-
	obtem_melhor(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
  destino(Nodo).

aestrela(Caminhos, SolucaoCaminho) :-
	obtem_melhor(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_aestrela(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
        aestrela(NovoCaminhos, SolucaoCaminho).


obtem_melhor([Caminho], Caminho) :- !.

obtem_melhor([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).

obtem_melhor([_|Caminhos], MelhorCaminho) :-
	obtem_melhor(Caminhos, MelhorCaminho).

expande_aestrela(Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacente(Caminho,NovoCaminho), ExpCaminhos).

adjacente([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
	percurso(Nodo, ProxNodo, Carreira, PassoCusto),\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCusto,
	estimativa(ProxNodo, Est).
