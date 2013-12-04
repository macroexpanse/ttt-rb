var ttt = angular.module('ttt', []);

ttt.controller('TTTCtrl', ['$scope', '$http', function($scope, $http) {
  $scope.cells = [
    {'id' : '0', 'row' : '0', 'column' : '0', 'right_x' : null, 'value': ''}, 
    {'id' : '1', 'row' : '0', 'column' : '1', 'right_x' : null, 'value': ''}, 
    {'id' : '2', 'row' : '0', 'column' : '2', 'right_x' : '0', 'value': ''},
    {'id' : '3', 'row' : '1', 'column' : '0', 'right_x' : null, 'value': ''}, 
    {'id' : '4', 'row' : '1', 'column' : '1', 'right_x' : '1', 'value': ''}, 
    {'id' : '5', 'row' : '1', 'column' : '2', 'right_x' : null, 'value': ''},
    {'id' : '6', 'row' : '2', 'column' : '0', 'right_x' : '2', 'value': ''}, 
    {'id' : '7', 'row' : '2', 'column' : '1', 'right_x' : null, 'value': ''}, 
    {'id' : '8', 'row' : '2', 'column' : '2', 'right_x' : null, 'value': ''}
  ];

  $scope.rows = [
    {'id': '0', 'cells' : [
      $scope.cells[0], 
      $scope.cells[1], 
      $scope.cells[2]
    ]},
    {'id': '1', 'cells' : [
      $scope.cells[3], 
      $scope.cells[4], 
      $scope.cells[5]
    ]},
    {'id': '2', 'cells' : [
      $scope.cells[6], 
      $scope.cells[7], 
      $scope.cells[8]
    ]}
  ]; 

  var move = '1';

  $scope.addValue = function(cellId) {
    var cell = $scope.cells[cellId]
    if(cell.value === '') {
      cell['value'] = 'X';
      $http({
        method: 'GET',
        url: 'http://localhost:4567/game.json',
        //Can't send array over params for some reason
        params: { 'cell0' : $scope.cells[0], 'cell1' : $scope.cells[1], 'cell2' : $scope.cells[2], 'cell3' : $scope.cells[3], 'cell4' : $scope.cells[4], 'cell5' : $scope.cells[5], 'cell6' : $scope.cells[6], 'cell7' : $scope.cells[7], 'cell8' : $scope.cells[8], 'move': move }
      }).success(function(data, status) {
        console.log('data', data)
        $scope.cells = data.cells
        $scope.rows = [
          {'id': '0', 'cells' : [
            $scope.cells[0], 
            $scope.cells[1], 
            $scope.cells[2]
          ]},
          {'id': '1', 'cells' : [
            $scope.cells[3], 
            $scope.cells[4], 
            $scope.cells[5]
          ]},
          {'id': '2', 'cells' : [
            $scope.cells[6], 
            $scope.cells[7], 
            $scope.cells[8]
          ]}
        ]; 
        move++;
      })
    };
  };
}]);