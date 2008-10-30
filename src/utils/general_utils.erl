-module(general_utils).
-compile(export_all).
-include("noe.hrl").

%%
%% Check for Ajax requests
%%
%% Most js libraries specify an additional header durig Ajax requests
%% Older libraries used to pass "HTTP_X_REQUESTED_WITH"
%% The new convention is to pass "X-Requested-With"
%%

is_xhr(A) ->
	Headers = yaws_headers:other(A),
	Header = get_header(Headers, "HTTP_X_REQUESTED_WITH"),
	
	case Header of
		"XMLHttpRequest" ->
			true;
		_ ->
			case get_header(Headers, "X-Requested-With") of
				"XMLHttpRequest" ->
					true;
				_ ->
					false
			end
	end.
	
	
get_header([], _) ->
	[];
get_header(L, Header) ->
	Headers = lists:filter(fun(E) -> case E of {http_header, _, Header, _, Val} -> true; _ -> false end end, L),
	case Headers of
		[] ->
			[];
		[{http_header, _, H, V}] ->
			V;
		_ ->
			lists:flatmap(fun({http_header, _, _, _, V2}) -> V2 end, Headers)
	end.




