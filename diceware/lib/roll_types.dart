class Roll {
    String type;
    int rollsNeeded;
    List<String> roll;

    Roll(this.type, this.rollsNeeded);

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

    WordRoll(String lang) : super('Words', 5);

    @override
    void checkRoll() {
  }
}

class ASCIIRoll extends Roll {
    ASCIIRoll() : super('ASCII', 3);

    @override
    void checkRoll() {
  }
}

class AlphaNumRoll extends Roll {
    AlphaNumRoll() : super('Alphanumeric', 2);

    @override
    void checkRoll() {
    }

}

class NumberRoll extends Roll {
    NumberRoll() : super('Numbers', 6);

    @override
    void checkRoll() {
  }

}