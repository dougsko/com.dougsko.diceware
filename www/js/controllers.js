angular.module('diceware.controllers', [])

.controller('DicewareCtrl', function($scope, $stateParams, $sce, $http, $ionicLoading) {
    $scope.outputTypes = ['Words', 'ASCII', 'Alphanumeric', 'Numbers'];
    $scope.selectedOutputType = $scope.outputTypes[0];
    $scope.dicts = ['Standard English', 'Alternative English', 'Catalan', 'Dutch', 'Esparanto', 'German', 'Japanese', 'Polish', 'Swedish'];
    $scope.selectedDict = $scope.dicts[0];
    $scope.totalRolls = 5;
    $scope.numRolls = 0;
    $scope.roll = '';
    $scope.oldRoll = null;
    $scope.mode = 0;
    $scope.output = '';
    $scope.words = diceware.words;


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
                    $scope.output += $scope.words[$scope.roll] + ' ';
                    resetRolls();
                }
                break;
            case 1:
                if($scope.roll.length == 3) {
                    if(diceware.ascii[$scope.roll] == 'null') {
                        $ionicLoading.show({ template: 'Please roll again!', noBackdrop: true, duration: 2000 });
                    }
                    else {
                        $scope.output += diceware.ascii[$scope.roll] + ' ';
                    }
                    resetRolls();
                }
                break;
            case 2:
                if($scope.roll.length == 2) {
                    $scope.output += diceware.alphanumeric[$scope.roll] + ' ';
                    resetRolls();
                }
                break;
            case 3:
                if ( $scope.roll.substring(0) == "6") {
                    $ionicLoading.show({ template: 'Please roll again!', noBackdrop: true, duration: 2000 });
                    $scope.roll = ''; 
                    resetRolls();
                }
                if($scope.roll.length == 2){
                    var firstDigitString = $scope.roll.substring(0, 1);
                    var secondDigitString = $scope.roll.substring(1);

                    var firstDigitInt = parseInt(firstDigitString);
                    var secondDigitInt = parseInt(secondDigitString);

                    // is the second roll even? if so, add 5 to first
                    // roll. 10 becomes 0.
                    if(secondDigitInt % 2 == 0) {
                        var outputInt = firstDigitInt + 5;
                        var outputString = outputInt.toString();
                        $scope.output += outputString.substring(outputString.length - 1) + ' ';
                        $scope.roll = '';
                    }
                    else {
                        $scope.output += firstDigitString + ' ';
                        $scope.roll = '';
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

    // when the user changes dictionary
    $scope.updateDict = function(dict) {
        $scope.selectedDict = dict;
        if(dict == 'Standard English') {
            $scope.words = diceware.words;
        }
        else if(dict == 'Alternative English') {
            $scope.words = diceware.alternative;
        }
        else if(dict == 'Catalan') {
            $scope.words = diceware.catalan;
        }
        else if(dict == 'Dutch') {
            $scope.words = diceware.dutch;
        }
        else if(dict == 'Esperanto') {
            $scope.words = diceware.esperanto;
        }
        else if(dict == 'German') {
            $scope.words = diceware.german;
        }
        else if(dict == 'Japanese') {
            $scope.words = diceware.japanese;
        }
        else if(dict == 'Polish') {
            $scope.words = diceware.polish;
        }
        else if(dict == 'Swedish') {
            $scope.words = diceware.swedish;
        }
        else {
        }
    }

    $scope.randomOrg = function() {
        var i = 5;
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
        $http.get('https://www.random.org/integers/?num=' + i + '&min=1&max=6&col=1&base=10&format=plain').then(function(resp) {
            $scope.roll = resp.data.replace(/\n/g, '');
            if($scope.roll == $scope.oldRoll) {
                resetRolls();
                return;
            }
            $scope.oldRoll = $scope.roll;
            checkRoll();
        }, function(err) {
            console.error('ERR', err);
            console.log(err.status);
            // err.status will contain the status code
        })
        $scope.waiting = false;
    }

    $scope.copyToClipboard = function() {
        cordova.plugins.clipboard
            .copy($scope.output.trim())
            .then(function() {
                $ionicLoading.show({ template: 'Passphrase copied.', noBackdrop: true, duration: 1000 });
            }, function() {
                $ionicLoading.show({ template: 'Error copying passphrase.', noBackdrop: true, duration: 1000 });
            });
    }

    $scope.clearOutput = function() {
        $scope.output = "";
        $scope.roll = 0;
        resetRolls();
    }

})
