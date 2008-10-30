-module(noe_app_controller).
-export([hook/1]).
-include("noe.hrl").

hook(A) ->
    A1 = normalize_appmoddata(A),
    case erlyweb:get_initial_ewc({ewc, A1}) of
		{page, "/"} -> start(A1);
		{page, "/static" ++ _Static} = Ewc -> Ewc;
		{page, "/favicon.ico"} = Ewc2 -> Ewc2;
		_Ewc -> start(A1)
    end.



start(A) ->
    Appmod = yaws_arg:appmoddata(A),	
    Appmod1 = 
		case Appmod of
			"/" ->
				"/main";
			_ ->
				Appmod
		end,
    A3 = yaws_arg:appmoddata(A, Appmod1),
	{phased, 
		{ewc, A3},
		fun(_Ewc, Data, PhasedVars) ->
			{ewc, html_container, [A3, Data, PhasedVars]}
		end
	}.


%% to avoid annoying Yaws inconsistencies
%% taken from Yariv Sadan's Twoorl, http://code.google.com/p/twoorl/
normalize_appmoddata(A) ->
    Val1 = 
	case yaws_arg:appmoddata(A) of
	    [] ->
		"/";
	    Val = [$/ | _] ->
		Val;
	    Val ->
		[$/ | Val]
	end,
    yaws_arg:appmoddata(A, Val1).
	
		
	    
