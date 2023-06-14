-module(headers).

-export([success/0, not_found/0]).

cors() -> "Access-Control-Allow-Origin: *\r\nAccess-Control-Allow-Method: *\r\n".
success() -> "200 OK\r\nContent-Type: application/json" ++ cors().
not_found() -> "404 Not Found".
