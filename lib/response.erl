-module(response).

-export([send/3]).

send(Socket, Headers, Body) -> gen_tcp:send(Socket, ["HTTP/1.1 ", Headers, "\r\n\r\n", Body]).
