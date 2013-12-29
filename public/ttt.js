var ttt = angular.module('ttt', []);

ttt.controller('TTTCtrl', ['$scope', '$http', function($scope, $http) {

  $scope.cells = [
    {'id' : '0', 'row' : '0', 'column' : '0', 'right_x' : false, 'left_x' : true,  'value': ''}, 
    {'id' : '1', 'row' : '0', 'column' : '1', 'right_x' : false, 'left_x' : false,  'value': ''}, 
    {'id' : '2', 'row' : '0', 'column' : '2', 'right_x' : true, 'left_x' : false, 'value': ''},
    {'id' : '3', 'row' : '1', 'column' : '0', 'right_x' : false, 'left_x' : false,  'value': ''}, 
    {'id' : '4', 'row' : '1', 'column' : '1', 'right_x' : true, 'left_x' : true, 'value': ''}, 
    {'id' : '5', 'row' : '1', 'column' : '2', 'right_x' : false, 'left_x' : false,  'value': ''},
    {'id' : '6', 'row' : '2', 'column' : '0', 'right_x' : true, 'left_x' : false, 'value': ''}, 
    {'id' : '7', 'row' : '2', 'column' : '1', 'right_x' : false, 'left_x' : false,  'value': ''}, 
    {'id' : '8', 'row' : '2', 'column' : '2', 'right_x' : false, 'left_x' : true,  'value': ''}
  ];

  $scope.newGame = function() {
    $scope.cells.map(function(cell) { cell.value =  ''; cell.win = null })
    $scope.move = 1;
    $scope.winningCells = [];
  };

  $scope.getRows = function() {
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
  };

  $scope.getRows();
  $scope.move = 1;
  $scope.losses = 0;
  $scope.ties = 0;
  $scope.winningCells = [];

  $scope.addValue = function(cellId) {
    var cell = $scope.cells[cellId]
    if(cell.value === '' && $scope.winningCells.length === 0) {
      cell['value'] = 'X';
      $http({
        method: 'GET',
        url: '/game.json',
        //Can't send array over params for some reason
        params: { 'cell0' : $scope.cells[0], 
                  'cell1' : $scope.cells[1], 
                  'cell2' : $scope.cells[2], 
                  'cell3' : $scope.cells[3], 
                  'cell4' : $scope.cells[4], 
                  'cell5' : $scope.cells[5], 
                  'cell6' : $scope.cells[6], 
                  'cell7' : $scope.cells[7], 
                  'cell8' : $scope.cells[8], 
                  'move': $scope.move 
        }
      }).success(function(data, status) {
        $scope.cells = data.cells;
        $scope.winningCells = $scope.cells.filter(function(cell) { return cell.win === true });
        var filledCells = $scope.cells.filter(function(cell) { return cell.value !== "" });
        if ($scope.winningCells.length > 0) {
          $scope.losses++;
        } else if (filledCells.length == 9) {
          $scope.ties++;
        };
        $scope.getRows();
        $scope.move++;
      });
    };
  };
}]);