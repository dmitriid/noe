%% @author Dmitrii 'Mamut' Dimandt <dmitrii@dmitriid.com>
%% @copyright 2008 Dmitrii 'Mamut' Dimandt
%% @doc General validation functions
-module(form_utils).

%%
%% Exported Functions
%%
-export([
         post/2, 
         post/3,
         get/2,
         get/3,
         request/2,
         request/3]).

%%
%% Provides functionality similar to PHP's $_POST, $_GET, $_REQUEST
%% You can provide a default value to return if the field is not present
%%


post(A, FieldName) ->
    post(A, FieldName, <<"">>).
post(A, FieldName, DefaultValue) ->
    try
	    case yaws_api:postvar(A, FieldName) of
    	    undefined ->
        	    DefaultValue;
        	{ok, Data} ->
            	Data
    	end
	catch
        _:_ -> DefaultValue
	end.

get(A, FieldName) ->
    get(A, FieldName, <<"">>).
get(A, FieldName, DefaultValue) ->
	try
    	case yaws_api:queryvar(A, FieldName) of
        	undefined ->
            	DefaultValue;
        	{ok, Data} ->
            	Data
    	end
	catch
		_:_ -> DefaultValue
	end.

request(A, FieldName) ->
    request(A, FieldName, <<"">>).
request(A, FieldName, DefaultValue) ->
	try
    	case yaws_api:getvar(A, FieldName) of
        	undefined ->
            	DefaultValue;
        	{ok, Data} ->
            	Data
    	end
	catch
		_:_ -> DefaultValue
	end.
