-module(parse).

-export([http/1]).

http(Request) ->
    [Body | Rest] = lists:reverse(string:split(Request, "\r\n\r\n", all)),
    [Http | Headers] = string:split(Rest, "\r\n", all),
    [Method, Path, _] = string:tokens(Http, " "),
    {Method, Path, Body, Headers}.
