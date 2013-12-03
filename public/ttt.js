var ttt = angular.module('ttt', []);

ttt.controller('TTTCtrl', ['$scope', function($scope) {
	$scope.cell1 = 'X';
	$scope.cell2 = 'X';
	$scope.cell3 = 'O';
}]);

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
