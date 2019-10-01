import 'dart:ui';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'roll_types.dart';

void main() => runApp(Diceware());

class Diceware extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Diceware',
            theme: ThemeData(
                primarySwatch: Colors.green,
                accentColor: Colors.green,
                brightness: Brightness.dark,
            ),
            home: StatefulHome(),
        );
    }
}

class ClipButton extends StatelessWidget {
    final String text;

    ClipButton(this.text);
    @override
    Widget build(BuildContext context) {
        return Expanded(
            child: Column(
                children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.content_copy),
                        color: Colors.green,
                        onPressed: () {
                            if (text == '') {
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                    content: new Text(text + "Nothing to copy"),
                                ));
                            } else {
                                Clipboard.setData(new ClipboardData(text: text));
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                    content: new Text(text + " Copied to clipboard"),
                                ));
                            }
                        },
                    ),
                    Text('Copy'),
                ],
            ),
        );
    }
}

class StatefulHome extends StatefulWidget {
    StatefulHome({Key key}) : super(key: key);

    @override
    _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<StatefulHome> {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    String langValue = 'Standard English';
    String outputTypeValue = 'Words';
    String output = '';
    var roll = Roll('Words');
    var availableLangs = [
        'Standard English',
        'Alternative English',
        'Catalan',
        'Dutch',
        'EFF',
        'Esperanto',
        'German',
        'Japanese',
        'Polish',
        'Spanish',
        'Swedish'
    ];
    var outputTypes = ['Words', 'ASCII', 'Alphanumeric', 'Numbers'];
    Widget langDropdown;

    _MyStatefulWidgetState() {
        setLang('Standard English');
    }

    void displaySnackBar(String text) {
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text(text)));
    }

    void localRandom() {
        var random = Random.secure();
        List<String> value = [];
        roll.roll.clear();
        for(int i = 0; i < roll.numRollsNeeded; i++) {
            numberPress((random.nextInt(6) + 1).toString());
        }
    }

    Future<Response> randomOrg() async {
        //String url = 'https://www.random.org/integers/?num=' + roll.numRollsNeeded.toString() + '&min=1&max=6&col=1&base=10&format=plain';
        String url = 'https://www.random.org/integers/?num=5&min=1&max=6&col=1&base=10&format=plain';
        url = 'http://dougsko.com';
        var response = await get(url);
        print(response);
        return response;
    }

    void processRandomOrg() {
        randomOrg().then((response) {
            setState(() {
                print(response.body.toString());
            });
        });
    }


    void clearOutput() {
        setState(() {
            output = '';
            roll = Roll(outputTypeValue);
            roll.numRollsSoFar = 0;
            roll.roll.clear();
        });
    }


    void numberPress(String number) {
        setState(() {
            roll.makeRoll(number);
            if(roll.numRollsNeeded == roll.numRollsSoFar) {
                if(roll.dict[roll.getRoll()] == 'null') {
                    roll.roll.clear();
                    roll.numRollsSoFar = 0;
                    displaySnackBar('Returned null.  Please re-roll!');
                } else {
                    roll.passphrase.add(roll.dict[roll.getRoll()]);
                    roll.numRollsSoFar = 0;
                    roll.roll.clear();
                }
            }
        });
    }

    void setLang(String lang) async {
        String dictPath;
        if(lang == 'Standard English') {
            dictPath = 'assets/dictionaries/std_english.json';
        } else if(lang == 'Alternative English') {
            dictPath = 'assets/dictionaries/alt_english.json';
        } else if(lang == 'Catalan') {
            dictPath = 'assets/dictionaries/catalan.json';
        } else if(lang == 'Dutch') {
            dictPath = 'assets/dictionaries/dutch.json';
        } else if(lang == 'EFF') {
            dictPath = 'assets/dictionaries/eff.json';
        } else if(lang == 'Esperanto') {
            dictPath = 'assets/dictionaries/esperanto.json';
        } else if(lang == 'German') {
            dictPath = 'assets/dictionaries/german.json';
        } else if(lang == 'Japanese') {
            dictPath = 'assets/dictionaries/japanese.json';
        } else if(lang == 'Polish') {
            dictPath = 'assets/dictionaries/polish.json';
        } else if(lang == 'Spanish') {
            dictPath = 'assets/dictionaries/spanish.json';
        } else if(lang == 'Swedish') {
            dictPath = 'assets/dictionaries/swedish.json';
        } else if(lang == 'ASCII') {
            dictPath = 'assets/dictionaries/ascii.json';
        }
        Map langMap = await rootBundle.loadStructuredData(dictPath, (String s) async {
            return json.decode(s);
        });
        roll.dict = langMap;
        //print(roll.dict['12345']);
    }

    Container generateOutputSection() {
        Widget outputSection = Container(
            padding: new EdgeInsets.all(10),
            //top: 10,
            //bottom: 10,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    /*
                    Text(
                        'Output',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                        ),
                    ),
                     */
                    Container(
                        padding: new EdgeInsets.only(
                            left: 10,
                            right: 10,
                        ),
                        decoration: new BoxDecoration(
                            color: Colors.white.withOpacity(0.20),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                            children: <Widget>[
                                Expanded(
                                    child: Text(
                                        //output,
                                        roll.formatPassphrase(),
                                        style: TextStyle(
                                            fontFamily: 'Verdana',
                                            fontSize: 30.0,
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    ),
                    Container(
                        padding: new EdgeInsets.only(
                            top: 10,
                        ),
                        child: Text(
                            'Rolls ' +
                                roll.numRollsSoFar.toString() +
                                '/' +
                                roll.numRollsNeeded.toString(),
                            textScaleFactor: 0.8,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                            ),
                        ),
                    ),
                ],
            ),
        );
        return outputSection;
    }

    Expanded generateDieButton(String number) {
        String unicode = '';
        String asset;
        switch (number) {
            case '1':
                unicode = '\u2680';
                asset = 'assets/dice-1.svg';
                break;
            case '2':
                unicode = '\u2681';
                asset = 'assets/dice-2.svg';
                break;
            case '3':
                unicode = '\u2682';
                asset = 'assets/dice-3.svg';
                break;
            case '4':
                unicode = '\u2683';
                asset = 'assets/dice-4.svg';
                break;
            case '5':
                unicode = '\u2684';
                asset = 'assets/dice-5.svg';
                break;
            case '6':
                unicode = '\u2685';
                asset = 'assets/dice-6.svg';
                break;
        }
        return Expanded(
            flex: 10,
            child: RawMaterialButton(
                //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.all(0),
                child: SvgPicture.asset(
                    asset,
                    color: Colors.green,
                    semanticsLabel: 'dice',
                    height: 50,
                    width: 50,
                ),
                onPressed: () {
                    numberPress(number);
                },
                shape: CircleBorder(),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        Widget dieButtons = Container(
            padding: new EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 10,
            ),
            child: Row(
                children: [
                    generateDieButton('1'),
                    Spacer(),
                    generateDieButton('2'),
                    Spacer(),
                    generateDieButton('3'),
                    Spacer(),
                    generateDieButton('4'),
                    Spacer(),
                    generateDieButton('5'),
                    Spacer(),
                    generateDieButton('6'),
                ],
            ),
        );

        Widget randomButtons = Container(
            padding: new EdgeInsets.all(10),
            child: Row(
                children: <Widget>[
                    Expanded(
                        flex: 10,
                        child: MaterialButton(
                            child: Text('Local PRNG'),
                            color: Colors.green,
                            textColor: Colors.white,
                            onPressed: () {
                                localRandom();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))),
                    ),
                    Spacer(
                        flex: 1,
                    ),
                    Expanded(
                        flex: 10,
                        child: MaterialButton(
                            child: Text('Random.org'),
                            color: Colors.green,
                            textColor: Colors.white,
                            onPressed: () {
                                processRandomOrg();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))),
                    ),
                    Expanded(
                        flex: 10,
                        child: FutureBuilder<Response>(
                          future: randomOrg(),
                          builder: (context, snapshot) {
                              if(snapshot.hasData) {
                                  print(snapshot);
                              }
                            return MaterialButton(
                                child: Text('Random 2'),
                                color: Colors.green,
                                textColor: Colors.white,
                                onPressed: () {
                                    processRandomOrg();
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)));
                          }
                        ),
                    ),
                ],
            ),
        );

        if (roll.type == 'Words') {
            langDropdown = Container(
                padding: new EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: 10,
                ),
                child: Row(
                    children: <Widget>[
                        //Icon(Icons.language),
                        Expanded(
                            flex: 1,
                            child: Text(
                                'Dictionary:',
                                textScaleFactor: 0.9,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),
                                ),
                            ),
                        ),
                        Expanded(
                            flex: 3,
                            child: DropdownButton<String>(
                                value: langValue,
                                //icon: Icon(Icons.language),
                                isExpanded: false,
                                onChanged: (String newValue) {
                                    setState(() {
                                        langValue = newValue;
                                        roll = WordRoll(langValue);
                                        setLang(langValue);
                                    });
                                },
                                items: availableLangs
                                    .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                    );
                                }).toList(),
                            ),
                        ),
                    ],
                ),
            );
        } else {
            langDropdown = Container();
        }

        if(roll.type == 'ASCII') {
            setLang('ASCII');
        }

        Widget outputType = Container(
            padding: new EdgeInsets.only(
                left: 10,
                right: 10,
            ),
            child: Row(
                children: <Widget>[
                    //Icon(Icons.grade),
                    // foo
                    Expanded(
                        flex: 1,
                        child: Text(
                            'Output Type:',
                            textScaleFactor: 0.9,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                            ),
                        ),
                    ),
                    Expanded(
                        flex: 3,
                        child: DropdownButton<String>(
                            value: outputTypeValue,
                            isExpanded: false,
                            onChanged: (String newValue) {
                                setState(() {
                                    outputTypeValue = newValue;
                                    if (outputTypeValue == 'Words') {
                                        roll = WordRoll(langValue);
                                    } else if (outputTypeValue == 'ASCII') {
                                        roll = ASCIIRoll();
                                    } else if (outputTypeValue == 'Alphanumeric') {
                                        roll = AlphaNumRoll();
                                    } else if (outputTypeValue == 'Numbers') {
                                        roll = NumberRoll();
                                    }
                                });
                            },
                            items: outputTypes.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                );
                            }).toList(),
                        ),
                    ),
                ],
            ),
        );

        Widget clearCopy = Container(
            padding: new EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: 10,
            ),
            child: Row(
                children: <Widget>[
                    ClipButton(roll.formatPassphrase()),
                    Expanded(
                        child: Column(
                            children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.clear),
                                    color: Colors.green,
                                    onPressed: clearOutput,
                                ),
                                Text('Clear'),
                            ],
                        ),
                    ),
                ],
            ),
        );

        return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        //Icon(Icons.casino),
                        //Text(' '),
                        Text('Diceware'),
                        //Text(' '),
                        //Icon(Icons.lock),
                    ],
                ),
            ),
            body: Builder(
                builder: (context) =>
                    Center(
                        // Center is a layout widget. It takes a single child and positions it
                        // in the middle of the parent.
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                generateOutputSection(),
                                dieButtons,
                                randomButtons,
                                outputType,
                                langDropdown,
                                clearCopy,
                            ],
                        ),
                    ),
            ),

            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    // Add your onPressed code here!
                },
                child: Icon(Icons.help),
            ),
        );
    }
}
