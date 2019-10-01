class Roll {
    String type;
    int numRollsNeeded;
    int numRollsSoFar = 0;
    List<String> roll = [];
    var dict;

    Roll(this.type) {
        if(type == 'Words') {
            numRollsNeeded = 5;
        } else if(type == 'ASCII') {
            numRollsNeeded = 3;
        } else if(type == 'Alphanumeric') {
            numRollsNeeded = 2;
        } else if(type == 'Numbers') {
            numRollsNeeded = 2;
        }
    }

    void makeRoll(String number) {
        roll.add(number);
        numRollsSoFar += 1;
        if(numRollsSoFar == numRollsNeeded) {
            checkRoll();
        }
    }

    String checkRoll(){
        return null;
    }

    @override
    String toString() {
        return [this.type, this.numRollsNeeded, this.numRollsSoFar].join(', ');
    }
}

class WordRoll extends Roll {
    String lang;

    WordRoll(this.lang) : super('Words');

    @override
    String checkRoll() {
        print(this.dict[this.roll]);
        return(this.dict[this.roll]);
  }
}

class ASCIIRoll extends Roll {
    ASCIIRoll() : super('ASCII');

    @override
    String checkRoll() {
        return null;
  }
}

class AlphaNumRoll extends Roll {
    AlphaNumRoll() : super('Alphanumeric');

    @override
    String checkRoll() {
       return null;
    }

}

class NumberRoll extends Roll {
    NumberRoll() : super('Numbers');

    @override
    String checkRoll() {
       return null;
  }

}