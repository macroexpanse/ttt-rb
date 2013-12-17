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

  function getRows($scope) {
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

  getRows($scope);

  var move = 1;

  $scope.addValue = function(cellId) {
    var cell = $scope.cells[cellId]
    if(cell.value === '') {
      cell['value'] = 'X';
      $http({
        method: 'GET',
        url: '/game.json',
        //Can't send array over params for some reason
        params: { 'cell0' : $scope.cells[0], 'cell1' : $scope.cells[1], 'cell2' : $scope.cells[2], 'cell3' : $scope.cells[3], 'cell4' : $scope.cells[4], 'cell5' : $scope.cells[5], 'cell6' : $scope.cells[6], 'cell7' : $scope.cells[7], 'cell8' : $scope.cells[8], 'move': move }
      }).success(function(data, status) {
        console.log('data', data)
        console.log('win', data.cells[9]);
        $scope.cells = data.cells;
        $scope.win = data.cells[9];
        getRows($scope);
        move++;
      });
    };
  };
}]);