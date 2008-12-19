-module(noe).
-compile(export_all).
-include("noe.hrl").
-include("noe_app.hrl").

start() ->
    process_flag(trap_exit, true),
    Inets = (catch application:start(inets)),
    start_phase(mysql, normal, [{?DB_HOSTNAME, ?DB_USERNAME, ?DB_PASSWORD, ?DB_DATABASE, ?DB_POOL_SIZE}]),
    start_phase(compile, normal, []),
    [{inets, Inets}].

start_phase(mysql, _Type, DBConfigs) ->
    [mysql_connect(Hostname, User, Password, Database, PoolSize)
     || {Hostname, User, Password, Database, PoolSize} <- DBConfigs],
    ok;

start_phase(compile, _Type, _Args) ->
    compile(),
    ok.

mysql_connect(Hostname, User, Password, Database, PoolSize) ->
    erlydb:start(
      mysql, [{hostname, Hostname},
	      {username, User},
	      {password, Password},
	      {database, Database},
	      {logfun, fun log/4}]),
    lists:foreach(
      fun(_PoolNumber) ->
	      mysql:connect(erlydb_mysql, Hostname, undefined, User, Password,
			    Database, true)
      end, lists:seq(1, PoolSize)).

compile() ->
    compile([]).

compile_dev() ->
    compile([{auto_compile, true}]).

compile_update() ->
    compile([{last_compile_time, auto}]).

compile(Opts) ->
    erlyweb:compile(compile_dir(default),
		    [{erlydb_driver, mysql}, {erlydb_timeout, 20000} | Opts]).

compile_dir(auto) ->
    {ok, CWD} = file:get_cwd(), CWD;
compile_dir(default) ->
    ?APP_PATH;
compile_dir(appconfig) ->
    {ok, CDir} = application:get_env(noe, compile_dir),
    CDir;
compile_dir(Dir) ->
    Dir.


%% This function is needed for logging in the mysql start_phase so I copied it here.
%% In the twoorl project it was located in twoorl_util.erl.
log(Module, Line, Level, FormatFun) ->
    Func = case Level of
	       debug ->
		   % info_msg;
		   undefined;
	       info ->
		   info_msg;
	       normal ->
		   info_msg;
	       error ->
		   error_msg;
	       warn ->
		   warning_msg
	   end,
    if Func == undefined ->
	    ok;
	true ->
	    {Format, Params} = FormatFun(),
	    error_logger:Func("~w:~b: "++ Format ++ "~n",
			      [Module, Line | Params])
    end.