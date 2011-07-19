$( document ).ready ->
	$( "#new_person" ).bind "ajax:success", ( evt, data, status, xhr ) ->
		$( "#new_expense" ).replaceWith data
