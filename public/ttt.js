var ttt = angular.module('ttt', []);

ttt.controller('TTTCtrl', ['$scope', '$http', function($scope, $http) {

  $scope.height = 3;
  $scope.getRows = function() {
    $scope.rows = [];
    for(i=0; i < $scope.height; i++) {
      $scope.rows.push({'cells' : [], 'height' : $scope.height });
      for(ii=0; ii < $scope.height; ii++) {
        $scope.rows[i].cells.push($scope.cells[i * $scope.height + ii]);
      };
    };
  };

  $scope.generateBoard = function() {
    $scope.cells = [];
    $scope.rows = [];
    var numberOfCells = Math.pow($scope.height, 2)
    for(i=0; i < numberOfCells; i++) {
      var rows = 'abcd';
      var row = rows[Math.floor(i / $scope.height)];
      var column = i % $scope.height + 1;
      $scope.cells.push({'id' : i, 'position' : row + column, 'value' : null})
    };
    $scope.getRows();
  };

  $scope.generateBoard();

  $scope.newGame = function() {
    $scope.cells.map(function(cell) { cell.value =  null; cell.win = null });
    $scope.turn = 1;
    $scope.winningCells = [];
    $scope.filledCells = [];
  };

  $scope.humanValue = 'X';
  $scope.ai = 'minimax';
  $scope.firstPlayerName = 'human'

  $scope.aiValue = function() {
    return ($scope.humanValue === 'X') ? 'O' : 'X';
  };

  $scope.getRows();
  $scope.turn = 1;
  $scope.losses = 0;
  $scope.ties = 0;
  $scope.winningCells = [];

  $scope.addValue = function(cellId) {
    var cell = $scope.cells[cellId]
    var playerCells = $scope.cells.filter(function(cell) { return cell.value === $scope.humanValue });
    var aiCells = $scope.cells.filter(function(cell) { return cell.value === $scope.aiValue() });
    var requiredCellDifference = ($scope.firstPlayerName === 'human') ? 0 : 1
    if($scope.winningCells.length === 0 && (aiCells.length - playerCells.length) === requiredCellDifference && cell.value == null) {
      cell.value = $scope.humanValue;
      $scope.getGameJSON();
    };
  };

  $scope.getGameJSON = function() {
    var params = {  'turn' : $scope.turn, 'human_value' : $scope.humanValue, 
                    'ai' : $scope.ai };
    for(i=0; i < Math.pow($scope.height, 2); i++) { params["cell" + i] = $scope.cells[i]; };
    $http({
      method: 'GET',
      url: '/make_next_move.json',
      params: params
    }).success($scope.setupNextMove);
  };

  $scope.setupNextMove = function(data) {
    $scope.cells = data;
    $scope.filledCells = $scope.cells.filter(function(cell) { return cell.value !== null });
    $scope.winningCells = $scope.cells.filter(function(cell) { return cell.win === true });
    incrementScoreboard();
    $scope.getRows();
    $scope.turn++;
  };

  incrementScoreboard = function() {
    if ($scope.winningCells.length > 0) {
      $scope.losses++;
    } else if ($scope.filledCells.length === Math.pow($scope.height, 2)) {
      $scope.ties++;
    };
  };
}]);
