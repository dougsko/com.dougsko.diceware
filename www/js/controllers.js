angular.module('diceware.controllers', [])

.controller('DicewareCtrl', function($scope, $stateParams, $sce, $http, $ionicLoading, $cordovaSQLite, database) {
    $scope.outputTypes = ['Words', 'ASCII', 'Alphanumeric', 'Numbers'];
    $scope.selectedOutputType = $scope.outputTypes[0];
    $scope.totalRolls = 5;
    $scope.numRolls = 0;
    $scope.roll = '';
    $scope.mode = 0;
    $scope.output = '';

    // when the user presses a number
    $scope.numberPress = function(number) {
        $scope.roll += number.toString();
        checkRoll();
    }

    incrementRoll = function() {
        $scope.numRolls += 1;
    }

    resetRolls = function() {
        $scope.numRolls = 0;
        $scope.roll = '';
    }

    checkRoll = function() {
        incrementRoll();
        switch ($scope.mode) {
            case 0:
                if($scope.roll.length == 5) {
                    database.getWord($scope.roll).then(function(res) { 
                        $scope.output += res + ' '; 
                    }, function(res) {
                        console.err(res);
                    });
                    resetRolls();
                }
                break;
            case 1:
                if($scope.roll.length == 3) {
                    database.getAscii($scope.roll).then(function(res) {
                        if(res == 'null') {
                            $ionicLoading.show({ template: 'Please roll again!', noBackdrop: true, duration: 1000 });
                        }
                        else {
                            $scope.output += res + ' ';
                        }
                    }, function(res) {
                        console.err(res);
                    });
                    resetRolls();
                }
                break;
            case 2:
                if($scope.roll.length == 2) {
                    database.getAlphaNumeric($scope.roll).then(function(res) { 
                        $scope.output += res + ' '; 
                    }, function(res) {
                        console.err(res);
                    });
                    resetRolls();
                }
                break;
            case 3:
                if ($scope.roll.substring(0) == "6") {
                    $ionicLoading.show({ template: 'Please roll again!', noBackdrop: true, duration: 1000 });
                    resetRolls();
                }
                if($scope.roll.length == 2){
                    firstDigitString = $scope.roll.substring(0, 1);
                    secondDigitString = $scope.roll.substring(1);

                    firstDigitInt = parseInt(firstDigitString);
                    secondDigitInt = parseInt(secondDigitString);

                    // is the second roll even? if so, add 5 to first
                    // roll. 10 becomes 0.
                    if(secondDigitInt % 2 == 0) {
                        outputInt = firstDigitInt + 5;
                        outputString = outputInt.toString();
                        $scope.output += outputString.substring(outputString.length - 1) + ' ';
                        $scope.roll = '';
                    }
                    else {
                        $scope.output += firstDigitString + ' ';
                    }
                    resetRolls();
                }
                break;
            default:
                break;
        }
    }

    // when the user changes output type
    $scope.updateType = function(type) {
        $scope.selectedOutputType = type;
        $scope.mode = $scope.outputTypes.indexOf(type);
        resetRolls();
        if(type == 'Words') {
            $scope.totalRolls = 5;
        }
        else if(type == 'ASCII') {
            $scope.totalRolls = 3;
        }
        else if(type == 'Alphanumeric') {
            $scope.totalRolls = 2;
        }
        else if(type == 'Numbers') {
            $scope.totalRolls = 2;
        }
        else {
            // do nothing
        }
        $ionicLoading.show({ template: 'Roll ' + $scope.totalRolls + ' times.', noBackdrop: true, duration: 1000 });
    }

    $scope.randomOrg = function() {
        i = 5;
        switch($scope.mode) {
                case 1:
                    i = 3;
                    break;
                case 2:
                    i = 2;
                    break;
                case 3:
                    i = 2;
                    break;
                default:
                    i = 5;
                    break;
            }
        $http.get('https://www.random.org/integers/?num=' + i + '&min=1&max=6&col=1&base=10&format=plain&rnd=new')
            .then(function(resp) {
                $scope.roll = resp.data.replace(/\n/g, '');
                checkRoll();
            }, function(err) {
                console.error('ERR', err);
                // err.status will contain the status code
            })
    }

    $scope.copyToClipboard = function() {
        output = '';
        if($scope.output != 'undefined')
        {
            output = $scope.output.trim();
        }
        cordova.plugins.clipboard
            .copy(output)
            .then(function() {
                $ionicLoading.show({ template: 'Passphrase copied.', noBackdrop: true, duration: 1000 });
            }, function() {
                $ionicLoading.show({ template: 'Error copying passphrase.', noBackdrop: true, duration: 1000 });
            });
    }

    $scope.clearOutput = function() {
        $scope.output = "";
        resetRolls();
    }

})

.factory('database', function($cordovaSQLite) {
    return {
        getWord: function(roll) {
            query = "select word from words where number = ?";
            return $cordovaSQLite.execute(db, query, [roll]).then(function(res) {
                result = res.rows.item(0)['word'];
                return result;
            }, function (err) {
                console.error(err);
            });
        },
        getAscii: function(roll) {
            query = "select char from asciis where number = ?";
            return $cordovaSQLite.execute(db, query, [roll]).then(function(res) {
                result = res.rows.item(0)['char'];
                return result;
            }, function (err) {
                console.error(err);
            });

        },
        getAlphaNumeric: function(roll) {
            query = "select char from alphanumerics where number = ?";
            return $cordovaSQLite.execute(db, query, [roll]).then(function(res) {
                result = res.rows.item(0)['char'];
                return result;
            }, function (err) {
                console.error(err);
            });
        }

    }
})
