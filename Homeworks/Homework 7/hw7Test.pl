consult(hw7).
findall(Y, duplist([1,2,3], Y), L), L = [[1,1,2,2,3,3]].
findall(Y, duplist([],[]), L), L = [true].


duplist([],[]).
duplist([0],[0]).
duplist([0],[0,0]).
duplist([[]],Y).
duplist([[1]],Y).
duplist([[1,2]],Y).
duplist(Y,[[1,2]]).
duplist(Y,[1,1]).
duplist(X,[]).
duplist(X,[1,2,3]).
duplist(X,[1,1,2,2,3,3]).
duplist([1,2], [1,2,1,2]).



put(1,hello,[[2,two]],D).
put(1,hello,[[1,one],[2,two]],D).
put(1,hello,[[1,one],[2,two]],D).
put(1,hello,D,[[2,two],[1,hello]]).
get(1,[[2,two],[1,hello]],V).
get(1,[[2,two],[1,hello]],V).
get(1,[[2,two],[1,hello]],V).
get(K,[[2,hello],[1,hello]],hello).
get(K,[[2,hello],[1,hello]],hello).
get(K,[[2,hello],[1,hello]],hello).
get(K,[[2,hello],[1,hello]],hello).
get(K,[[2,two],[1,hello]],V).
put(1,hello,[[1,one],[2,two]],D).
put(1, hello, [[2, bye], [3, hi]], [[3, hi], [2, bye], [1, hello]]).


eval(intconst(2),[],X).
eval(intconst(2),[],intval(2)).
eval(intconst(2),[],intval(4)).

eval(boolconst(4),[],boolval(4)).
eval(boolconst(4),[],X).
eval(boolconst(4),[[intconst(3),intval(3)]],X).

eval(var(x),[],intval(3)).
eval(var(x), E ,intval(3)).
eval(var(x), E ,intval(3)).
eval(var(x), [[var(x),intval(3)]] ,intval(3)).
eval(var(x), [[var(y),intval(3)]] ,intval(3)).
eval(var(x), [[var(y),intval(3)]|E] ,intval(3)).
eval(var(x), [[var(y),intval(3)]|E] ,intval(3)).
eval(var(x), [[var(x),intval(3)],[var(y),intval(4)]] ,X).
eval(var(x), [[var(z),intval(3)],[var(y),intval(4)]] ,X).
eval(var(x), [[var(x),intval(3)],[var(y),intval(4)]] ,X).
eval(var(x), [[var(x),intval(3)],[var(y),intval(4)]] ,X).
eval(var(x), [[var(y),intval(4)],[var(x),intval(3)]] ,X).
eval(var(x), [[var(y),intval(4)],[var(x),intval(3)]] ,X).
eval(var(x), [[var(y),intval(3)]|E] ,intval(3)).
eval(var(x), E ,intval(3)).
eval(var(x), [[var(y),intval(4)],[var(x),intval(3)],[var(z),boolval(true)]] ,X).
eval(var(x), [[var(y),intval(4)],E,[var(z),boolval(true)]] ,intval(3)).
eval(var(x), [E,[var(z),boolval(true)]] ,intval(3)).
eval(var(x), [E,[var(z),boolval(true)],[]] ,intval(3)).
eval(var(x), [[]] ,intval(3)).

eval(geq(intval(3),intval(4)),[],X).
eval(geq(intconst(3),intconst(4)),[],X).
eval(geq(var(x),var(y)),[[var(x),intval(3)],[var(y),intval(4)]],X).
eval(geq(var(x),var(y)),[[var(x),intval(4)],[var(y),intval(3)]],X).

eval( if( geq( intconst(3), intconst(4)), var(x), var(y)), [[var(x), intval(100)], [var(y), intval(10)]], V ).
eval( if( geq( intconst(5), intconst(4)), var(x), var(y)), [[var(x), intval(100)], [var(y), intval(10)]], V ).
eval( if( geq( var(x), var(y)), var(x), var(y)), [[var(x), intval(100)], [var(y), intval(10)]], V ).
eval( if( geq( var(x), var(y)), var(x), var(y)), [[var(x), intval(100)], [var(y), intval(1000)]], V ).
eval( if( geq( var(x), var(y)), var(x), var(y)), [ [var(y), intval(1000)]], V ).
eval( if( geq( var(x), var(y)), var(x), var(y)), [ ], V ).

eval(function(x,intconst(3)), E, V).

eval(funcall(function(x,if(geq(var(x),intconst(0)),intconst(1),intconst(0))), intconst(34)), [], V).
eval(funcall(function(x,intconst(5)), intconst(34)), [], V).


eval(function(x,if(geq(var(x),intconst(0)),intconst(1),intconst(0))), [[var(x), intval(34)]], V).


length(Actions,L), blocksworld(world([a,b,c],[],[],none), Actions, world([],[],[a,b,c],none)).
length(Actions,L), blocksworld(world([],[],[],none), Actions, world([],[],[],none)).
length(Actions,L), blocksworld(world([a,b,c,d],[],[],none), Actions, world([],[],[a,b,c,d],none)).
length(Actions,L), blocksworld(world([a,b],[c],[],none), Actions, world([],[],[a,b,c],none)).
length(Actions,L), blocksworld(world([a,b],[c],[],d), Actions, world([],[],[a,b,c,d],none)).
