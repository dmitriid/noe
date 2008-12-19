-define(L(Msg), io:format("~p:~b ~p ~n", [?MODULE, ?LINE, Msg])).

-define(Debug(Msg, Params),
	noe:log(?MODULE, ?LINE, debug, fun() -> {Msg, Params} end)).
-define(Info(Msg, Params),
 	noe:log(?MODULE, ?LINE, info, fun() -> {Msg, Params} end)).
-define(Warn(Msg, Params),
 	noe:log(?MODULE, ?LINE, warn, fun() -> {Msg, Params} end)).
-define(Error(Msg, Params),
 	noe:log(?MODULE, ?LINE, error, fun() -> {Msg, Params} end)).
