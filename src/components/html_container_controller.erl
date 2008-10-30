-module(html_container_controller).
-export([private/0, index/3]).
-include("noe.hrl").

private() ->
    true.

index(A, Data, PhasedVars) ->
	case general_utils:is_xhr(A) of
		true ->
			%% we only need data in Ajax request
			{data, {xhr, Data}};
		_ ->
			%% we need both data and other stuff like menus in normal requests
    		[{data, Data}, {ewc, main_menu, [A]}] 
	end.
