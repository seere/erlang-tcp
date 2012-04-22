-module(clientstress).
-export([client_loop/2, start_many/0, start_many/2]).

-define(PORT, 7990).

% gets a timestamp in ms from the epoch
get_timestamp() ->
    {Mega,Sec,Micro} = erlang:now(),
    (Mega*1000000+Sec)*1000000+Micro.


client_loop(0,_MyNumber) ->
    io:format("EOL of ~w~n", [self()]);

client_loop(N,MyNumber) ->
    %io:format("Connecting new client: ~w~n", [self()]),
    {ok,Socket} = gen_tcp:connect("localhost",?PORT, [binary,{packet,0},{nodelay,true}]),
    MSG = io_lib:format("Hello from client ~w (~w) at ~w (count: ~w)~n",
                        [MyNumber, self(), get_timestamp(), N]),
    ok = gen_tcp:send(Socket, MSG),

    gen_tcp:close(Socket),
    client_loop(N-1,MyNumber).


start_many() ->
    start_many(10,10).


start_many(NumberOfClients,NumberOfRequests) ->
    [ spawn(?MODULE, client_loop, [NumberOfRequests,X]) || X <- lists:seq(1,NumberOfClients)].
    


                                  
