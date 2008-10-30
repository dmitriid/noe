-module(noe).
-compile(export_all).
-include("noe.hrl").
-include("noe_app.hrl").

start() ->
    application:start(inets),
    init_mysql(),
    compile().

compile() ->
    compile([]).

compile_dev() ->
    compile([{auto_compile, true}]).

compile_update() ->
    compile([{last_compile_time, auto}]).

compile(Opts) ->
    erlyweb:compile(?APP_PATH,
		    [{erlydb_driver, mysql}, {erlydb_timeout, 20000} | Opts]).

init_mysql() ->
    erlydb:start(mysql,
		 [{hostname, ?DB_HOSTNAME},
		  {username, ?DB_USERNAME}, {password, ?DB_PASSWORD},
		  {database, ?DB_DATABASE}]),
    lists:foreach(
      fun(_) ->
	      mysql:connect(erlydb_mysql, ?DB_HOSTNAME, undefined,
			    ?DB_USERNAME, ?DB_PASSWORD, ?DB_DATABASE, true)
      end, lists:seq(1, ?DB_POOL_SIZE)).

