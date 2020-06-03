pesquisarbfs(NodoInicial,NodoFinal) :-
        evolucao(destino(NodoFinal)),
        rbfs([],[(NodoInicial/_/_, 0/0/0)],99999,_,yes,S),
        involucao(destino(NodoFinal)),
        reverse(S,Solucao),
        duracao(Solucao,D),
        escreve_resultado(Solucao,D).

rbfs(Caminho,[(Nodo/Filho/Carreira, G/F/FF)|Nodos],Limite,FF,no,_) :-
        FF > Limite, !.

rbfs(Caminho,[(Nodo/Filho/Carreira, G/F/FF)|_],_,_,yes,[Nodo/Filho/Carreira|Caminho]) :-
        F = FF,
        destino(Nodo).

rbfs(_,[],_,_,never,_) :- !.

rbfs(Caminho,[(Nodo/Filho/Carreira,G/F/FF)|Nodos],Limite,NovoFF,S,Solucao) :-
        FF =< Limite,
        findall(Nodo/Filho/Carreira/Custo, (percurso(Nodo,Filho,Carreira,Custo),
        \+ member(Nodo/Filho/Carreira,Caminho)),Filhos),
        herda(F,FF,FFHerdado),
        succlist(G,FFHerdado,Filhos,NodosSuc),
        bestff(Nodos,ProxMelhorFF),
        min(Limite,ProxMelhorFF,NLimite),!,
        rbfs([Nodo/Filho/Carreira|Caminho],NodosSuc,NLimite,NovoFF2,S2,Solucao),
        continua(Caminho,[(Nodo/Filho/Carreira, G/F/NovoFF2)|Nodos],Limite,NovoFF,S2,S,Solucao).

continua(Caminho,[[Nodo,Filho,Carreira]|Ns],Limite,NovoFF,never,S,Solucao) :- !,
        rbfs(Caminho,Ns,Limite,NovoFF,S,Solucao).

continua(_,_,_,_,yes,yes,Solucao).

continua(Caminho,[[Nodo,Filho,Carreira]|Ns],Limite,NovoFF,no,S,Solucao) :-
        insert([Nodo,Filho,Carreira],Ns,NovoNs), !,
        rbfs(Caminho,NovoNs,Limite,NovoFF,S,Solucao).

succlist(_,_,[],[]).

succlist(G0,FFHerdado,[Nodo/Filho/Carreira/C|NCs],Nodos) :-
        G is G0 + C,
        estimativa(Nodo,H),
        F is G + H,
        max(F,FFHerdado,FF),
        succlist(G0,FFHerdado,NCs,Nodos2),
        insert((Nodo/Filho/Carreira,G/F/FF),Nodos2,Nodos).

herda(F,FF,FF) :- FF > F,!.
herda(F,FF,0).

insert((Nodo/Filho/Carreira,G/F/FF),Nodos,[(Nodo/Filho/Carreira,G/F/FF)|Nodos]) :-
      bestff(Nodos,FF2),
      FF =< FF2, !.

insert(N,[N1/F/C|Ns],[N1/F/C|Ns1]) :-
      insert(N,Ns,Ns1).

bestff([(Nodo/Filho/Carreira,F/G/FF)|Ns],FF).
bestff([],99999).