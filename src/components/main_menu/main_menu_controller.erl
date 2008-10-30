-module(main_menu_controller).

-export([index/1]).

%% Obviously, we need different menus on different pages
%% secondary_menu might not be a good name, but it sort of conveys the idea
index(A) ->
    Appmod = yaws_arg:appmoddata(A),
	case Appmod of
		"/main" ->
			{data, main_menu};
		"/note" ++ _ ->
			{data, secondary_menu}
	end.