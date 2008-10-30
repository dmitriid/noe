-module(note_controller).

-include("noe.hrl").


-export([
	add/1,
	edit/2,
	delete/2
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                     %%%
%%% Exported functions  %%%
%%%                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%% add/1
%%
%% If request is GET (normal request)
%%    Display form
%% If request is POST (we are adding a note)
%%    Add note
%%    If the request is via Ajax
%%        Return Ajax stuff
%%    Else
%%        Return to main page (return ewr)
%%

add(A) ->
	Xhr = general_utils:is_xhr(A),
	
	case yaws_arg:method(A) of
		'GET' ->
			{data, html};
		'POST' ->
			Title = form_utils:post(A, "title", ""),
			Text = form_utils:post(A, "text", ""),
			Errors = 
				if Title == "" andalso Text == "" ->
					empty;
				true ->
					ok
				end,
			case Errors of
				ok ->
					Note = add_note(Title, Text),
					
					case Xhr of
						false -> ewr;
						_ -> {data, {xhr, Note}}
					end;
				_ ->
					case Xhr of
						false -> {data, {html, Errors}};
						_ -> {data, {xhr, error, Errors}}
					end
			end
	end.
	
%%
%% edit/2
%%
%% If request is GET (normal request)
%%    Display form
%% If request is POST (we are adding a note)
%%    Update note
%%    If the request is via Ajax
%%        Return Ajax stuff
%%    Else
%%        Return to main page (return ewr)
%%

	
edit(A, ID) ->
	Xhr = general_utils:is_xhr(A),
	Notes = note:find({id, '=', ID}),
	case Notes of
		[] ->
			ewr;
		[Note] ->
			case yaws_arg:method(A) of
				'GET' ->
					case Xhr of
						true ->
							{data, {xhr, Note}};
						_ ->
							{data, {html, Note}}
					end;
				'POST' ->
					Title = form_utils:post(A, "title", ""),
					Text = form_utils:post(A, "text", ""),
					Errors = 
						if Title == "" andalso Text == "" ->
							empty;
						true ->
							ok
						end,
					case Errors of
						ok ->
							N = update_note(Title, Text, ID),
					
							case Xhr of
								false -> ewr;
								_ -> {data, {xhr, N, posted}}
							end;
						_ ->
							case Xhr of
								false -> {data, {html, Note, Errors}};
								_ -> {data, {xhr, Note, Errors}}
							end
					end
			end
	end.

%%
%% delete/2
%%
%% If request is GET (normal request)
%%    Display form
%% If request is POST (we are adding a note)
%%    Delete note
%%    If the request is via Ajax
%%        Return Ajax stuff
%%    Else
%%        Return to main page (return ewr)
%%

delete(A, ID) ->
	Xhr = general_utils:is_xhr(A),
	Notes = note:find({id, '=', ID}),
	case Notes of
		[] ->
			ewr;
		[Note] ->
			case yaws_arg:method(A) of
				'GET' ->
					case Xhr of
						true ->
							{data, {xhr, Note}};
						_ ->
							{data, {html, Note}}
					end;
				'POST' ->
					note:delete_id(ID),
			
					case Xhr of
						false -> ewr;
						_ -> {data, {xhr, Note, deleted}}
					end
			end
	end.
	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                         %%%
%%% Private/API functions   %%%
%%%                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


add_note(Title, Text) ->
	{T, Txt} = prepare_note(Title, Text),
	Note = note:new_with([{title, T}, {text, Txt}]),
	note:save(Note).

update_note(Title, Text, ID) ->	
	{T, Txt} = prepare_note(Title, Text),
	note:update([{title, T}, {text, Txt}], {id, '=', ID}),
	note:new_with([{id, ID}, {title, T}, {text, Txt}]).

prepare_note(Title, Text) ->
	Title1 = list_to_binary(Title),
	Text1 = list_to_binary(Text),
	Title2 = case Title1 of
		<<>> ->
			string_utils:ellipses(Text1, 32);
		_ ->
			Title1
	end,
	Title3 = string_utils:htmlize_lite(Title2),
	{Title3, Text1}.
	