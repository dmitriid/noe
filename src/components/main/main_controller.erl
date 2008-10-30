-module(main_controller).

-export([index/1]).

index(A) ->
	%% Dump all notes you can find
	Notes = note:find_with({order_by, [{when_created, desc}]}),
	{data, Notes}.
