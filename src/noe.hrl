-define(L(Msg), io:format("~p:~b ~p ~n", [?MODULE, ?LINE, Msg])).

-define(Debug(Msg, Params),
	general_utils:log(?MODULE, ?LINE, debug, fun() -> {Msg, Params} end)).
-define(Info(Msg, Params),
 	general_utils:log(?MODULE, ?LINE, info, fun() -> {Msg, Params} end)).
-define(Warn(Msg, Params),
 	general_utils:log(?MODULE, ?LINE, warn, fun() -> {Msg, Params} end)).
-define(Error(Msg, Params),
 	general_utils:log(?MODULE, ?LINE, error, fun() -> {Msg, Params} end)).
