var ttt = angular.module('ttt', []);

ttt.controller('TTTCtrl', ['$scope', function($scope) {
  $scope.rows = [
    {'id': '0', 'cells' : [
      {'id' : '0', 'rowId' : '0', 'position' : '0', 'value': ''}, 
      {'id' : '1', 'rowId' : '0', 'position' : '1', 'value': ''}, 
      {'id' : '2', 'rowId' : '0', 'position' : '2', 'value': ''}
    ]},
    {'id': '1', 'cells' : [
      {'id' : '3', 'rowId' : '1', 'position' : '0', 'value': ''}, 
      {'id' : '4', 'rowId' : '1', 'position' : '1', 'value': ''}, 
      {'id' : '5', 'rowId' : '1', 'position' : '2', 'value': ''}
    ]},
    {'id': '2', 'cells' : [
      {'id' : '6', 'rowId' : '2', 'position' : '0', 'value': ''}, 
      {'id' : '7', 'rowId' : '2', 'position' : '1', 'value': ''}, 
      {'id' : '8', 'rowId' : '2', 'position' : '2', 'value': ''}
    ]}
  ];

  var turn = 'X';

  $scope.addValue = function(rowId, cellId) {
    var cell = $scope.rows[rowId].cells[cellId - (rowId * 3)];
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