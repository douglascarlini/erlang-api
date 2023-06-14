-module(compiler).

-export([compile_all/1]).

compile_all(Directory) ->
    case file:list_dir(Directory) of
        {ok, FileList} ->
            compile_files(FileList, Directory);
        {error, Reason} ->
            io:format("Error: ~p~n", [Reason])
    end.

compile_files([], _) ->
    ok;
compile_files([File | Rest], Directory) ->
    Path = Directory ++ "/" ++ File,
    case filelib:is_regular(Path) of
        true ->
            [Module | _] = string:split(Path, ".erl"),
            io:format("[FILE]: ~s~n", [Module]),
            compile:file(Module);
        false ->
            io:format("Skip File: ~p~n", [File])
    end,
    compile_files(Rest, Directory).
