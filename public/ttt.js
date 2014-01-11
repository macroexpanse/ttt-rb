var ttt = angular.module('ttt', []);

ttt.controller('TTTCtrl', ['$scope', '$http', function($scope, $http) {

  $scope.cells = [];

  for(i=0; i < 9; i++) {
    var rows = 'abc';
    var row = rows[Math.floor(i / 3)];
    var column = i % 3 + 1;
    $scope.cells.push({'id' : row + column, 'value' : ''})
  };

  $scope.newGame = function() {
    $scope.cells.map(function(cell) { cell.value =  ''; cell.win = null });
    $scope.move = 1;
    $scope.winningCells = [];
    $scope.filledCells = [];
  };

  $scope.humanValue = 'X';
  $scope.filledCells = $scope.cells.filter(function(cell) { return cell.value !== "" });

  $scope.getRows = function() {
    $scope.rows = [];
    for(i=0; i < 3; i++) {
      $scope.rows.push({'cells' : [
        $scope.cells[i * 3],
        $scope.cells[i * 3 + 1],
        $scope.cells[i * 3 + 2]
      ]});
    };
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
      var params = {'move' : $scope.move, 'human_value' : $scope.humanValue};
      for(i=0; i < 9; i++) {
        params['cell' + i] = $scope.cells[i];
      };
      $http({
        method: 'GET',
        url: '/game.json',
        params: params
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