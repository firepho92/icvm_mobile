import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/Beer.dart';

class SecondPage extends StatefulWidget {
  SecondPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  _SecondPageState createState() => _SecondPageState();
  
}

class _SecondPageState extends State<SecondPage> {
  _SecondPageState({this.title});
  List<Beer> beers = List();
  List<DropdownMenuItem<String>> dropDownMenuItems;
  String currentBeer;
  String quantity;
  final String title;
  int serverResposeStatus = 0;
  

  var isLoadingDropdown= false;
  final serverIP = 'https://icvm-server.herokuapp.com/beers';
  
  void initState() {
    super.initState();
    print(title);
    if(beers.length == 0) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => this._fetchData());
    }
  }

  _fetchData() async {
    setState(() {
      isLoadingDropdown = true;
    });
    final response = await http.get(Uri.parse(serverIP));
    if(response.statusCode == 200) {
      beers = (json.decode(response.body) as List)
              .map((data) => new Beer.fromJson(data))
              .toList();
      dropDownMenuItems = getDropDownMenuItems();
      currentBeer = dropDownMenuItems[0].value;
      setState(() {
        isLoadingDropdown = false;
      });
    } else {
      throw Exception('Failed to fecth data from server');
    }
  }

  void changedDropDownItem(String selectedBeer) {
    setState(() {
      currentBeer = selectedBeer;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for(Beer beer in beers) {
      items.add(new DropdownMenuItem(value: beer.getId().toString(), child: Text(beer.getName()),));
    }
    //items = beers.map((beer) => DropdownMenuItem(value: beer.getName(), child: new Text(beer.getName())));
    return items;
  }

  void _addBeersToStock() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"id": "' + currentBeer.toString() + '","name":  "' + '' + '","quantity": "' + quantity + '"}';
    var response = await http.put(Uri.parse(serverIP), headers: headers, body: json);
    if(response.statusCode == 200) {
      _showNotification('Agregado correctamente');
    } else {
      _showNotification('No se puede conectar con el servidor');
    }
  }

  _showNotification(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Ocultar',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: isLoadingDropdown 
            ? Center(
              child: CircularProgressIndicator(),
            ) 
            : Scaffold(
              body: Center(
                child: Container(
                  width: 300.0,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Center(
                            child: DropdownButton(
                              value: currentBeer,
                              items: dropDownMenuItems,
                              onChanged: changedDropDownItem,
                            )
                          ),
                          Center(
                            child: Container(
                              width: 200.0,
                              child: TextField(
                                onChanged: (text) {quantity = text;},
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Cantidad:',
                                ),
                              )
                            ),
                          ),
                          Center(
                            child: RaisedButton(
                              child: Text('Agregar'),
                              onPressed: _addBeersToStock,
                              ),
                          )
                        ],
                      ),
                    )
                  )
                ),
              ),
            )
              
    );
  }
}