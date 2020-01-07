class Roll {
    String type;
    int numRollsNeeded;
    int numRollsSoFar = 0;
    List<String> roll = [];
    var dict;
    var passphrase = [];

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
        if(this.roll.length < this.numRollsNeeded) {
            roll.add(number);
            numRollsSoFar += 1;
        }
        /*
        if (numRollsSoFar == numRollsNeeded) {
            checkRoll();
        }
         */
    }

    String getRoll() {
        return this.roll.join('');
    }

    String formatPassphrase() {
        return this.passphrase.join(' ');
        /*
        if(this.type == 'Words') {
            return this.passphrase.join(' ');
        } else {
            return this.passphrase.join('');
        }
         */
    }

    void resetRoll() {
        this.roll.clear();
        this.numRollsSoFar = 0;
        //this.passphrase.clear();
    }

    @override
    String toString() {
        return [this.type, this.numRollsNeeded, this.numRollsSoFar, this.roll.toString(), this.passphrase].join(', ');
    }
}

class WordRoll extends Roll {
    String lang;

    WordRoll(this.lang) : super('Words');
}

class ASCIIRoll extends Roll {
    ASCIIRoll() : super('ASCII');
}

class AlphaNumRoll extends Roll {
    AlphaNumRoll() : super('Alphanumeric');

}

class NumberRoll extends Roll {
    NumberRoll() : super('Numbers');

}