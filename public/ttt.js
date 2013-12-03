$(function() {
	// $('h1').click(function() {
	// 	alert('clicked');
	// });

	var turn = 'X';
	
	$('td').click(function() {
		var id = this.id.replace('cell-', '');
		$(this).text(turn);
		if(turn == 'X') {
			turn = 'O';
		} else {
			turn = 'X';
		};
	});
});
