var ttt = angular.module('ttt', []);

ttt.controller('TTTCtrl', ['$scope', '$http', function($scope, $http) {

  $scope.cells = [];

  for(i=0; i < 9; i++) {
    var rows = 'abc';
    var row = rows[Math.floor(i / 3)];
    var column = i % 3 + 1;
    $scope.cells.push({'id' : i, 'position' : row + column, 'value' : null})
  };
  
  $scope.newGame = function() {
    $scope.cells.map(function(cell) { cell.value =  null; cell.win = null });
    $scope.move = 1;
    $scope.winningCells = [];
    $scope.filledCells = [];
  };

  $scope.humanValue = 'X';
  $scope.ai = 'minimax';
  $scope.firstPlayerName = 'human'

  $scope.aiValue = function() {
    return ($scope.humanValue === 'X') ? 'O' : 'X';
  };

  $scope.getRows = function() {
    $scope.rows = [];
    for(i=0; i < 3; i++) {
      $scope.rows.push({'cells' : [] });
      for(ii=0; ii < 3; ii++) {
        $scope.rows[i].cells.push(
          $scope.cells[i * 3 + ii]
        );
      };
    };
  };

  $scope.getRows();
  $scope.move = 1;
  $scope.losses = 0;
  $scope.ties = 0;
  $scope.winningCells = [];

  $scope.addValue = function(cellId) {
    var cell = $scope.cells[cellId]
    var playerCells = $scope.cells.filter(function(cell) { return cell.value === $scope.humanValue });
    var aiCells = $scope.cells.filter(function(cell) { return cell.value === $scope.aiValue() });
    if($scope.firstPlayerName == 'human') {
      if($scope.winningCells.length === 0 && playerCells.length === aiCells.length && cell.value == null || cell.value == '') {
        cell.value = $scope.humanValue;
        $scope.getGameJSON();
      };
    } else {
      if($scope.winningCells.length === 0 && playerCells.length === (aiCells.length - 1) && cell.value == null || cell.value == '') {
        cell.value = $scope.humanValue;
        $scope.getGameJSON();
      };
    };
  };

  $scope.getGameJSON = function() {
    var params = {  'move' : $scope.move, 'human_value' : $scope.humanValue, 'ai_value' : $scope.aiValue(), 'ai' : $scope.ai, 'first_player_name' : $scope.firstPlayerName };
    for(i=0; i < 9; i++) {
      params["cell" + i] = $scope.cells[i];
    };
    $http({
      method: 'GET',
      url: '/make_next_move.json',
      params: params
    }).success($scope.setupNextMove);
  };

  $scope.setupNextMove = function(data) {
    $scope.cells = data.cells;
    $scope.filledCells = $scope.cells.filter(function(cell) { return cell.value === 'X' || cell.value === 'O' });
    $scope.winningCells = $scope.cells.filter(function(cell) { return cell.win === true });
     if ($scope.winningCells.length > 0) {
      $scope.losses++;
    } else if ($scope.filledCells.length == 9) {
      $scope.ties++;
    };
    $scope.getRows();
    $scope.move++;
  };

}]);
