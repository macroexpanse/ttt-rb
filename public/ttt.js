var ttt = angular.module('ttt', []);

ttt.controller('TTTCtrl', ['$scope', '$http', function($scope, $http) {

  $scope.cells = [
    {'id' : 'a1', 'value': ''},
    {'id' : 'a2', 'value': ''},
    {'id' : 'a3', 'value': ''},
    {'id' : 'b1', 'value': ''},
    {'id' : 'b2', 'value': ''},
    {'id' : 'b3', 'value': ''},
    {'id' : 'c1', 'value': ''},
    {'id' : 'c2', 'value': ''},
    {'id' : 'c3', 'value': ''}
  ];

  $scope.newGame = function() {
    $scope.cells.map(function(cell) { cell.value =  ''; cell.win = null });
    $scope.move = 1;
    $scope.winningCells = [];
    $scope.filledCells = [];
  };

  $scope.humanValue = 'X';

  $scope.filledCells = $scope.cells.filter(function(cell) { return cell.value !== "" });

  $scope.getRows = function() {
    $scope.rows = [
      {'cells' : [
        $scope.cells[0],
        $scope.cells[1],
        $scope.cells[2]
      ]},
      {'cells' : [
        $scope.cells[3],
        $scope.cells[4],
        $scope.cells[5]
      ]},
      {'cells' : [
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
    var cell = $scope.cells.filter(function(cell) { return cell.id === cellId })[0];
    var playerCells = $scope.cells.filter(function(cell) { return cell.value === 'X' })
    var aiCells = $scope.cells.filter(function(cell) { return cell.value === 'O' })
    if(cell.value === '' && $scope.winningCells.length === 0 && playerCells.length === aiCells.length) {
      cell.value = $scope.humanValue;
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
                  'move': $scope.move,
                  'human_value' : $scope.humanValue
        }
      }).success(function(data, status) {
        $scope.filledCells = $scope.cells.filter(function(cell) { return cell.value !== "" });
        $scope.cells = data.cells;
        $scope.winningCells = $scope.cells.filter(function(cell) { return cell.win === true });
        if ($scope.winningCells.length > 0) {
          $scope.losses++;
        } else if ($scope.filledCells.length == 9) {
          $scope.ties++;
        };
        $scope.getRows();
        $scope.move++;
      });
    };
  };
}]);