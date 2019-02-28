import 'package:flutter/material.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> permutations = [];
  TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Material(
        child: Container(
          padding: EdgeInsets.all(8.0),
          color: Colors.blue,
          child: Column(
            children: <Widget>[
              Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            key: Key('search_text'),
                            decoration: InputDecoration(
                                labelText: 'Enter your Characters:'),
                            autofocus: true,
                            controller: textFieldController,
                            textInputAction: TextInputAction.search,
                            onFieldSubmitted: (text) {
                              setListState();
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: RaisedButton.icon(
                                  onPressed: () {
                                    setListState();
                                  },
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  icon: Icon(Icons.search),
                                  label: Center(
                                    child: Text('Search'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: permutations.length,
                    itemBuilder: (BuildContext ctxt, int index) =>
                        buildBody(ctxt, index)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    textFieldController.dispose();
    super.dispose();
  }

  Widget buildBody(BuildContext ctxt, int index) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Column(
        children: <Widget>[
          Text(
            permutations[index],
            style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ],
      )),
    ));
  }

  Future<List<String>> _getCombinations() {
    return new Future<List<String>>(() {
      var list = new List<String>();
      getCombinations(list, "", sanitizeString(textFieldController.text));
//    textFieldController.clear(); // Clear the Text area
      return list;
    });
  }

  void setListState() {
    _getCombinations().then((value) {
      permutations.clear();
      permutations.addAll(value);
    }).catchError((error) {
      print('Error');
      setState(() {}); // Redraw the Stateful Widget
    }).whenComplete(() {
      setState(() {}); // Redraw the Stateful Widget);
    });
  }
}

String sanitizeString(String line) {
  return line;
//  .replaceAll("[^a-zA-Z]", "").toLowerCase();
}

void getCombinations(List<String> list, String permutation, String input) {
  if (input.length == 0) {
    if (!list.contains(permutation)) list.add(permutation);
  } else {
    for (int i = 0; i < input.length; i++) {
      getCombinations(list, permutation + input[i],
          input.substring(0, i) + input.substring(i + 1, input.length));
    }
  }
}
