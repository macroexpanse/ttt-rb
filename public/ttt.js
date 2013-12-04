var ttt = angular.module('ttt', []);

ttt.controller('TTTCtrl', ['$scope', function($scope) {
  $scope.rows = [
    {'id': '0', 'cells' : [
      {'id' : '0', 'row' : '0', 'column' : '0', 'right_x' : null, 'value': ''}, 
      {'id' : '1', 'row' : '0', 'column' : '1', 'right_x' : null, 'value': ''}, 
      {'id' : '2', 'row' : '0', 'column' : '2', 'right_x' : '0', 'value': ''}
    ]},
    {'id': '1', 'cells' : [
      {'id' : '3', 'row' : '1', 'column' : '0', 'right_x' : null, 'value': ''}, 
      {'id' : '4', 'row' : '1', 'column' : '1', 'right_x' : '1', 'value': ''}, 
      {'id' : '5', 'row' : '1', 'column' : '2', 'right_x' : null, 'value': ''}
    ]},
    {'id': '2', 'cells' : [
      {'id' : '6', 'row' : '2', 'column' : '0', 'right_x' : '2', 'value': ''}, 
      {'id' : '7', 'row' : '2', 'column' : '1', 'right_x' : null, 'value': ''}, 
      {'id' : '8', 'row' : '2', 'column' : '2', 'right_x' : null, 'value': ''}
    ]}
  ];

  var turn = 'X';

  $scope.addValue = function(row, column) {
    var cell = $scope.rows[row].cells[column];
    if(cell.value === '') {
      cell.value = turn;
      if(turn === 'X') {
        turn = 'O';
      } else {
        turn = 'X';
      };
    };  
  }
}]);