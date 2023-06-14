-module(api).

-export([run/1]).

run(Port) ->
    io:format("[INFO]: Loading compiler...~n", []),
    compile:file("lib/compiler"),

    io:format("[INFO]: Compiling libs...~n", []),
    compiler:compile_all("lib"),

    io:format("[INFO]: Compiling mods...~n", []),
    compiler:compile_all("src"),

    io:format("[INFO]: API on ~p...~n", [Port]),
    socket:listen(Port, fun req/5).

req(Socket, Method, Path, Body, _) ->
    io:format("[HTTP]: [~s] ~s ~s~n", [socket:get_ip(Socket), Method, Path]),

    case Method of
        "OPTIONS" ->
            response:send(Socket, "204 No Content", "");
        _ ->
            % error counter
            Errors = counters:new(1, [atomics]),

            % categories
            case categories:router(Path, Method, Body) of
                {ok, A} -> response:send(Socket, headers:success(), A);
                _ -> counters:add(Errors, 1, 1)
            end,

            % products
            case products:router(Path, Method, Body) of
                {ok, B} -> response:send(Socket, headers:success(), B);
                _ -> counters:add(Errors, 1, 1)
            end,

            % pets
            case pets:router(Path, Method, Body) of
                {ok, C} -> response:send(Socket, headers:success(), C);
                _ -> counters:add(Errors, 1, 1)
            end,

            % not found
            case counters:get(Errors, 1) of
                3 -> response:send(Socket, headers:not_found(), "");
                _ -> ""
            end
    end.
