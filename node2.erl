-module(node2).
-export([start/0]).

start() ->
    %% Start Erlang node
    ok = net_kernel:start([node2, shortnames]),

    %% Create listening socket
    {ok, ListenSocket} = gen_tcp:listen(1234, [binary, {active, false}]),

    %% Accept incoming connection
    {ok, Socket} = gen_tcp:accept(ListenSocket),

    %% Send and receive messages
    loop(Socket),

    %% Close socket
    gen_tcp:close(Socket),

    %% Close listening socket
    gen_tcp:close(ListenSocket),

    %% Stop Erlang node
    net_kernel:stop().

loop(Socket) ->
    %% Receive message
    case gen_tcp:recv(Socket, 0) of
        {ok, Message} ->
            %% Print message
            io:format("Received message: ~s~n", [Message]),
            %% Send response
            io:format("Enter message to send: "),
            MessageToSend = io:get_line(""),
            gen_tcp:send(Socket, MessageToSend),
            %% Continue loop
            loop(Socket);
        {error, closed} ->
            %% Socket closed by other end
            io:format("Connection closed by other end.~n");
        _ ->
            %% Error
            io:format("Error receiving message.~n")
    end.
