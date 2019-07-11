import 'package:flutter/material.dart';
import 'package:icvm_mobile/context/AppContext.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/Beer.dart';

class FirstPage extends StatefulWidget {
  FirstPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  _FirstPageState createState() => _FirstPageState();
  
}

class _FirstPageState extends State<FirstPage> with RouteAware {
  _FirstPageState({this.title});
  List<Beer> list = List();
  final String title;

  /*_sustractBeerCount(index) {
    list[index].quantity -= 1;
  }*/

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      floatingActionButton: buildSendButton(),
      body: buildFirstPage()
              
    );
  }
}

var beerData = (Beer beer) => beer.name + ': ' + beer.amount.toString();

var buildFirstPage = () => ScopedModelDescendant<AppContext>(
  builder: (context, child, model) => buildBeerData()
);

var buildBeerData = () => ScopedModelDescendant<AppContext>(
  builder: (context, child, model) => ListView.builder(
    itemCount: model.beers.length,
    itemBuilder: (BuildContext context, int index) {
      return Card(
        child: ListTile(
          contentPadding: EdgeInsets.all(10.0),
          title: new Text(beerData(model.beers[index])),
          trailing: IconButton(
            icon: Icon(Icons.add), onPressed: () => model.addBeerCount(index),
          )
        )
      );
    }
  )
);

var buildSendButton = () => ScopedModelDescendant<AppContext>(
  builder: (context, child, model) => FloatingActionButton(
    child: Icon(Icons.send),
    onPressed: () => model.putData(context),
  )
);