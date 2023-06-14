-module(socket).

-export([listen/2, get_ip/1]).

listen(Port, Run) ->
    {ok, Client} = gen_tcp:listen(Port, []),
    socket(Client, Run).

socket(Client, Run) ->
    {ok, Socket} = gen_tcp:accept(Client),
    receive
        {tcp, Socket, Request} ->
            {Method, Path, Body, Headers} = parse:http(Request),
            Run(Socket, Method, Path, Body, Headers);
        _ ->
            Error = "405 Not Supported",
            response:send(Socket, Error, Error)
    end,
    gen_tcp:close(Socket),
    socket(Client, Run).

get_ip(Socket) ->
    case inet:peername(Socket) of
        {ok, {IP, _Port}} -> inet_parse:ntoa(IP);
        _ -> ""
    end.
