-module(products).

-export([router/3, create/1, update/2, delete/1, read/1, list/0]).

router(Path, Method, Body) ->
    A = re:run(Path, "^/products$"),
    B = re:run(Path, "^/products(/\d)$"),
    if
        B /= nomatch andalso Method =:= "PUT" -> {ok, update(Path, Body)};
        B /= nomatch andalso Method =:= "DELETE" -> {ok, delete(Path)};
        A /= nomatch andalso Method =:= "POST" -> {ok, create(Body)};
        B /= nomatch andalso Method =:= "GET" -> {ok, read(Path)};
        A /= nomatch andalso Method =:= "GET" -> {ok, list()};
        true -> {false, ""}
    end.

create(Data) ->
    io:format("Data: ~p~n", [Data]),
    "{\"data\":\"Product Created\"}".

update(Path, Data) ->
    io:format("Data: ~p~n", [Data]),
    [Id | _] = string:tokens(Path, "/"),
    "{\"data\":\"Product #" ++ Id ++ " Updated\"}".

delete(Path) ->
    io:format("Path: ~p~n", [Path]),
    [Id | _] = string:tokens(Path, "/"),
    "{\"data\":\"Product #" ++ Id ++ " Deleted\"}".

read(Path) ->
    io:format("Path: ~p~n", [Path]),
    [Id | _] = string:tokens(Path, "/"),
    "{\"data\":\"Product #" ++ Id ++ "\"}".

list() ->
    "{\"data\":[]}".
