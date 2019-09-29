import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                            if(text == '') {
                                Scaffold.of(context).showSnackBar(
                                    new SnackBar(content: new Text(text + "Nothing to copy"),));
                            }
                            else {
                                Clipboard.setData(
                                    new ClipboardData(text: text));
                                Scaffold.of(context).showSnackBar(
                                    new SnackBar(content: new Text(
                                        text + " Copied to Clipboard"),));
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
    String roll = '';
    var availableLangs = ['Standard English', 'Alternative English', 'Catalan', 'Dutch', 'EFF', 'Esperanto', 'German', 'Japanese', 'Polish', 'Spanish', 'Swedish'];
    var outputTypes = ['Words', 'ASCII', 'Alphanumeric', 'Numbers'];
    var rollType = Roll('Words');
    Widget langDropdown;

    void clearOutput() {
        setState(() {
            output = '';
        });
    }

    void numberPress(String number) {
        setState(() {
            roll += number;
            output += number; // for debugging
        });
    }

    Container generateOutputSection() {
        Widget outputSection = Container(
            padding: new EdgeInsets.all(10),
            //top: 10,
            //bottom: 10,
            child: Column(
                children: <Widget>[
                    Text(
                        'Output:',
                        style: TextStyle(
                            color: Colors.green.withOpacity(0.75),
                        ),
                    ),
                    Text(
                        output,
                        style: TextStyle(),
                    ),
                    Text(
                        'Rolls 0/5',
                        textScaleFactor: 0.8,
                        style: TextStyle(
                            color: Colors.green.withOpacity(0.75),
                        ),
                    ),
                ],
            ),
        );
        return outputSection;
    }

    Expanded generateDieButton(String number) {
        String unicode = '';
        switch (number) {
            case '1':
                unicode = '\u2680';
                break;
            case '2':
                unicode = '\u2681';
                break;
            case '3':
                unicode = '\u2682';
                break;
            case '4':
                unicode = '\u2683';
                break;
            case '5':
                unicode = '\u2684';
                break;
            case '6':
                unicode = '\u2685';
                break;
        }
        return Expanded(
            flex: 10,
            child: RaisedButton(
                //constraints: BoxConstraints(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.all(0),
                child: Text(
                    unicode,
                    textScaleFactor: 3,
                    style: TextStyle(
                        color: Colors.green,
                    ),
                ),
                color: Colors.white,
                //textColor: Colors.white,
                onPressed: () {
                    numberPress(number);
                },
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
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

        Widget randomButton = Container(
            padding: new EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 10,
            ),
            child: Row(
                children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: MaterialButton(
                            child: Text('Random.org'),
                            color: Colors.green,
                            textColor: Colors.white,
                            onPressed: () {},
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                        ),
                    ),
                ],
            ),
        );

        if(rollType.type == 'Words') {
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
                                    color: Colors.green.withOpacity(0.75),
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
                                    });
                                },
                                items: availableLangs
                                    .map<DropdownMenuItem<String>>((
                                    String value) {
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
                                color: Colors.green.withOpacity(0.75),
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
                                    if(outputTypeValue == 'Words') {
                                        rollType = WordRoll(langValue);
                                    } else if(outputTypeValue == 'ASCII') {
                                        rollType = ASCIIRoll();
                                    } else if(outputTypeValue == 'Alphanumeric') {
                                        rollType = AlphaNumRoll();
                                    } else if(outputTypeValue == 'Numbers') {
                                        rollType = NumberRoll();
                                    }
                                });
                            },
                            items: outputTypes
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
                        randomButton,
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
