import 'dart:ui';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

    void clearOutput() {
        setState(() {
            output = '';
            roll = Roll(outputTypeValue);
        });
    }

    void numberPress(String number) {
        setState(() {
            roll.makeRoll(number);
            //output += number; // for debugging
            output += roll.checkRoll().toString();
        });
    }

    void setLang(String lang) async {
        String dictPath;
        if(lang == 'Standard English') {
            dictPath = 'assets/dictionaries/std_english.json';
        } else if(lang == 'Alternative English') {
            dictPath = 'assets/dictionaries/alt_english.json';
        }
        Map langMap = await rootBundle.loadStructuredData(dictPath, (String s) async {
            return json.decode(s);
        });
        roll.dict = langMap;
        print(langMap['12345']);
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
                                        output,
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
                            onPressed: () {},
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
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))),
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
                    ClipButton(output),
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
            body: Center(
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
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    // Add your onPressed code here!
                },
                child: Icon(Icons.help),
            ),
        );
    }
}
