class Roll {
    String type;
    int rollsNeeded;
    List<String> roll;

    Roll(this.type) {
        if(type == 'Words') {
            rollsNeeded = 5;
        } else if(type == 'ASCII') {
            rollsNeeded = 3;
        } else if(type == 'Alphanumeric') {
            rollsNeeded = 2;
        } else if(type == 'Numbers') {
            rollsNeeded = 6;
        }
    }

    void makeRoll(String number) {
        roll.add(number);
        if(roll.length == rollsNeeded) {
            checkRoll();
        }
    }

    void checkRoll(){}
}

class WordRoll extends Roll {
    String lang;

    WordRoll(this.lang) : super('Words');

    @override
    void checkRoll() {
  }
}

class ASCIIRoll extends Roll {
    ASCIIRoll() : super('ASCII');

    @override
    void checkRoll() {
  }
}

class AlphaNumRoll extends Roll {
    AlphaNumRoll() : super('Alphanumeric');

    @override
    void checkRoll() {
    }

}

class NumberRoll extends Roll {
    NumberRoll() : super('Numbers');

    @override
    void checkRoll() {
  }

}