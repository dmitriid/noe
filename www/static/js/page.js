// global vars

var modal_box;

/*
	Click note title to open/close note
*/
function jsfy_notes(){
	var notes = $('div.note')
	var note_titles = notes.find('h2');

	note_titles
	    .unbind('click')
	    .bind('click', 
	        function(){
		    	var title = $(this);
		    	var text = $(this).siblings('div');
		    	if(title.is('.open') || text.is(':visible')){
					text.hide('fast');
					title.removeClass('open');
		    	}else{
					text.show('fast');
					title.addClass('open');
		    	}
	        }
	    )
	
}

/*
	Ajaxify add/edit/delete actions
*/


function jsfy_links(){
	
	/*
		Call
			toggle_visibility('hide', ':visible') to hide open divs
			toggle_visibility('open', ':hidden') to open closed divs
	*/
	var toggle_visibility = function(effect, filter){
		var text = $('div.note div').filter(filter);

		text.each(
			function(){
				var t = $(this);
				$.fn[effect].apply(t, ['fast']);
				
				var class_toggle = effect == 'hide' ? 'removeClass' : 'addClass';
				
				$.fn[class_toggle].apply(t.siblings('h2'), ['open']);
			}
		);
	}
	
	/*
		Get all relevant links
	*/
	
	var show_all = $('#show_all');
	var hide_all = $('#hide_all');
	var add_note = $('#add_note');
	var edit_note = $('a.edit');
	var delete_note = $('a.delete');
	
	/*
		Expand/collapse all
	*/
	show_all.click(
		function(){
			toggle_visibility('show', ':hidden');
			return false;
		}
	);
	hide_all.click(
		function(){
			toggle_visibility('hide', ':visible');
			return false;
		}
	);
	
	/*
		Add a new note.
			1. Display form
			2. Ajax post
			3. Prepend new note to the list of notes
	*/
	
	add_note.click(
		function(){			
			if(modal_box) modal_box.unload(); // prevent bug that caused previous box to reappear
			var box = new Boxy('#note_form form', {
				title: 'Add note',
				closeText: 'x',
				clone: true,
				modal: true,
				unloadOnHide: true,
				afterShow : function(){
					$(this.getContent()).ajaxForm(
						{
							success: function(resp){
								$.taconite(resp);
							}
						}
					).find('input').eq(0).focus();
					$(this.getContent()).find('a').click(function(){modal_box.hideAndUnload(); return false;});
				}
			});
			modal_box = box;
			return false;
		}
	);
	
	/*
		Edit note.
			1. Display box
			2. Ajax get form with note contents
			3. Ajax post new data
			4. Replace note with new data
	*/
	
	edit_note.click(
		function(){
			var id = $(this).parents('div').eq(0).attr('id');
			if(modal_box) modal_box.unload(); // prevent bug that caused previous box to reappear
			var box = new Boxy('#note_form form', {
				title: 'Edit note',
				closeText: 'x',
				clone: true,
				modal: true,
				unloadOnHide: true,
				afterShow : function(){
					this.getContent().html('Loading...')
					    .load(
							'/note/edit/' + id,
							function(){
								$(modal_box.getContent()).find('form').ajaxForm(
									{
										success: function(resp){
											$.taconite(resp);
										}
									}
								).find('input').eq(0).focus();
								$(modal_box.getContent()).find('a').click(function(){modal_box.hideAndUnload();return false;});
							}
					    );
				}
			});
			modal_box = box;			
			return false;
		}
	);
	
	/*
		Delete note.
			1. Display box
			2. Ajax get note contents and deletion form
			3. Ajax post
			4. Remove note from the list
	*/
	
	delete_note.click(
		function(){
			var id = $(this).parents('div').eq(0).attr('id');
			if(modal_box) modal_box.unload(); // prevent bug that caused previous box to reappear
			var box = new Boxy('#note_form form', {
				title: 'Delete note?',
				closeText: 'x',
				clone: true,
				modal: true,
				unloadOnHide: true,
				afterShow : function(){
					this.getContent().html('Loading...')
					    .load(
							'/note/delete/' + id,
							function(){
								$(modal_box.getContent()).find('form').ajaxForm(
									{
										success: function(resp){
											$.taconite(resp);
										}
									}
								).find('input').eq(0).focus();
								$(modal_box.getContent()).find('a').click(function(){modal_box.hideAndUnload();return false;});
							}
					    );
				}
			});
			modal_box = box;			
			return false;
		}
	);	
}


$(document).ready(
	function(){
		jsfy_notes();
		jsfy_links();
	}
);
