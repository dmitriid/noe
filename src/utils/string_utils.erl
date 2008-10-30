-module(string_utils).

-export([
	left/2,
	right/2,
	mid/3,
	ellipses/2,
	nl2br/1,
	htmlize_lite/1
]).

left(<<>>, _Offset) ->
	<<>>;
left(Str, Offset) ->
	{ok, Str1} = utf8:from_binary(Str),
	L = lists:sublist(Str1, Offset),
	{ok, S} = utf8:to_binary(L),
	S.
	
right(<<>>, _Offset) ->
	<<>>;
right(Str, Offset) ->
	{ok, Str1} = utf8:from_binary(Str),
	Length = lists:length(Str1),
	if 
		Length - Offset < Length -> Str;
		true ->
			L = lists:nthtail(Str1, Length-Offset),
			{ok, S} = utf8:to_binary(L),
			S
	end.

mid(<<>>, _Start, _Offset) ->
	<<>>;
mid(Str, Start, Offset) ->
	{ok, Str1} = utf8:from_binary(Str),
	L = lists:sublist(Str1, Start, Offset),
	{ok, S} = utf8:to_binary(L),
	S.

%%
%% ellipses("Text", 3) yields "Tex&hellip;"
%%
ellipses(Text, Offset) when is_list(Text) ->
	Length = length(Text),
	if 
		Length > Offset ->
			{ok, B} = utf8:to_binary(Text), 
			B1 = left(B, Offset),
			<<B1/binary, "&hellip;">>;
		true ->
			{ok, T} = utf8:to_binary(Text),
			T
	end;

ellipses(Text, Offset) when is_binary(Text) ->
	{ok, L}= utf8:from_binary(Text),
	ellipses(L, Offset).
	
%%
%% Converts newlines and carriage returns to <br />
%%

nl2br(List) when is_list(List) -> 
	{ok, NewString, _} = regexp:gsub(List, "\r\n|\n|\r", "<br />"),
	{ok, S} = utf8:to_binary(lists:flatten(NewString)), 
	S; 
nl2br(List) when is_binary(List) -> 
	{ok, L} = utf8:from_binary(List), 
	nl2br(L).
	

%%
%% only convert <,>," to &lt; &gt; &quot;
%%
%% Twoorl has a htmlize utility, http://github.com/yariv/twoorl/tree/master/src/twoorl_util.erl
%% However, it fails to play nicely with non-ASCII texts work, or, maybe, I'm using it incorrectly
%% Anyway, this "light" version should be enough for noe
%%

htmlize_lite(List) when is_binary(List) ->
	{ok, L} = utf8:from_binary(List), 
	htmlize_lite(L);
htmlize_lite(List) -> 
	{ok, NewString, _} = regexp:gsub(List, "<", "\\&lt;"),
	{ok, NewString2, _} = regexp:gsub(NewString, ">", "\\&gt;"),
	{ok, NewString3, _} = regexp:gsub(NewString2, "\"", "\\&quot;"),
	{ok, S} = utf8:to_binary(lists:flatten(NewString3)), 
	S.